//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftOpenAPIGenerator open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftOpenAPIGenerator project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftOpenAPIGenerator project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
import OpenAPIRuntime
import Foundation
import HTTPTypes

/// A middleware that retries the request under certain conditions.
///
/// Only meant to be used for illustrative purposes.
struct RetryingMiddleware {

    /// The failure signal that can lead to a retried request.
    enum RetryableSignal: Hashable {

        /// Retry if the response code matches this code.
        case code(Int)

        /// Retry if the response code falls into this range.
        case range(Range<Int>)

        /// Retry if an error is thrown by a downstream middleware or transport.
        case errorThrown
    }

    /// The policy to use when a retryable signal hints that a retry might be appropriate.
    enum RetryingPolicy: Hashable {

        /// Don't retry.
        case never

        /// Retry up to the provided number of attempts.
        case upToAttempts(count: Int)
    }

    /// The policy of delaying the retried request.
    enum DelayPolicy: Hashable {

        /// Don't delay, retry immediately.
        case none

        /// Constant delay.
        case constant(seconds: TimeInterval)
    }

    /// The signals that lead to the retry policy being evaluated.
    var signals: Set<RetryableSignal>

    /// The policy used to evaluate whether to perform a retry.
    var policy: RetryingPolicy

    /// The delay policy for retries.
    var delay: DelayPolicy

    /// Creates a new retrying middleware.
    /// - Parameters:
    ///   - signals: The signals that lead to the retry policy being evaluated.
    ///   - policy: The policy used to evaluate whether to perform a retry.
    ///   - delay: The delay policy for retries.
    init(
        signals: Set<RetryableSignal> = [.code(429), .range(500..<600), .errorThrown],
        policy: RetryingPolicy = .upToAttempts(count: 3),
        delay: DelayPolicy = .constant(seconds: 1)
    ) {
        self.signals = signals
        self.policy = policy
        self.delay = delay
    }
}

extension RetryingMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        guard case .upToAttempts(count: let maxAttemptCount) = policy else {
            return try await next(request, body, baseURL)
        }
        
        if let body { guard body.iterationBehavior == .multiple else { return try await next(request, body, baseURL) } }

        func willRetry() async throws {
            switch delay {
            case .none: return
            case .constant(seconds: let seconds): try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            }
        }

        var currentRequest = request

        for attempt in 1...maxAttemptCount {
            print("Attempt \(attempt)")

            let (response, responseBody): (HTTPResponse, HTTPBody?)

            // 오류 처리
            if signals.contains(.errorThrown) {
                do {
                    (response, responseBody) = try await next(currentRequest, body, baseURL)
                } catch {
                    if attempt == maxAttemptCount {
                        throw error
                    } else {
                        print("⚠️ Client 내부 오류로 인한 재요청")
                        try await willRetry()
                        continue
                    }
                }
            } else {
                (response, responseBody) = try await next(currentRequest, body, baseURL)
            }
            
            // 401 Unauthorized 응답 처리
            if response.status.code == 401 && attempt < maxAttemptCount {
                print("♻️ 401 Error, 리프레시 토큰 재발급 요청")

                // 토큰 갱신 시도
                do {
                    let tokenResponse = try await AuthEndpoint.refreshAccessToken()
                    guard let accesstoken = tokenResponse.accessToken,
                          let refreshToken = tokenResponse.refreshToken else {
                        throw AuthEndpointError.tokenResponseNotValid
                    }
                    
                    // 요청 헤더에 새로운 액세스 토큰을 추가
                    var newTokenHeader = currentRequest.headerFields
                    newTokenHeader.append(
                        HTTPField(
                            name: .authorization,
                            value: "Bearer \(accesstoken)"
                        )
                    )
                    
                    currentRequest.headerFields = newTokenHeader
                    continue  // 재시도 루프 다시 호출!
                } catch {
                    print("리프레시 토큰 발급 실패")
                    throw error  // 토큰 갱신 실패 시 오류 반환
                }
            }

            if signals.contains(response.status.code) && attempt < maxAttemptCount {
                print("⚠️ Status Code \(response.status.code) 로 인한 재요청")
                try await willRetry()
                continue
            } else {
                return (response, responseBody)
            }
        }
        
        preconditionFailure("Unreachable")
    }
}


extension Set where Element == RetryingMiddleware.RetryableSignal {
    /// Checks whether the provided response code matches the retryable signals.
    /// - Parameter code: The provided code to check.
    /// - Returns: `true` if the code matches at least one of the signals, `false` otherwise.
    func contains(_ code: Int) -> Bool {
        for signal in self {
            switch signal {
            case .code(let int): if code == int { return true }
            case .range(let range): if range.contains(code) { return true }
            case .errorThrown: break
            }
        }
        return false
    }
}
