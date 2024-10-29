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
import OpenapiGenerated
import Foundation
import HTTPTypes
import CoreKit

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
                do {
                    if let errorResponse = try await decodeErrorResponse(from: responseBody) {
                        print(errorResponse)
                        // accessToken 만료
                        if errorResponse.code == "1006" {
                            print("1006 들어옴")
                        }
                        // refreshToken 만료
                        if errorResponse.code == "1008" {
                            print("1008 들어옴")
                            // 끝, 로그인 할 방법 없음
                            AuthState.change(.loggedOut)
                            throw AuthEndpointError.refreshTokenExpired
                        }
                    } else {
                        print("디코딩 실패 !!")
                    }
                    
                    print("♻️ 401 Error, 리프레시 토큰 재발급 요청")
                    // 토큰 갱신 시도
                    // request
                    let response = try await AuthService.shared.refreshAccessToken()
                    
                    // ✅ 리프레시 토큰 response OK
                    if let tokenResponse = try? response.ok.body.json {
                        // 토큰 저장
                        TokenManager.accessToken = tokenResponse.accessToken
                        TokenManager.refreshToken = tokenResponse.refreshToken
                        // 요청 헤더에 새로운 액세스 토큰을 추가
                        var newTokenHeader = currentRequest.headerFields
                        newTokenHeader.append(
                            HTTPField(
                                name: .authorization,
                                value: "Bearer \(tokenResponse.accessToken)"
                            )
                        )
                        
                        currentRequest.headerFields = newTokenHeader
                        continue  // 재시도 루프 다시 호출!
                    }
                } catch {
                    print("리프레시 토큰 발급 실패")
                    AuthState.change(.loggedOut)
                    print(error)
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
    
    func decodeErrorResponse(from responseBody: HTTPBody?) async throws -> Components.Schemas.ErrorResponse? {
        guard let responseBody = responseBody else { return nil }
        
        // HTTP body를 String으로 변환 (최대 10MB까지)
        let jsonString = try await String(collecting: responseBody, upTo: 10 * 1024 * 1024)
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        
        let decoder = JSONDecoder()
        
        // ISO8601 날짜 포맷터 설정
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            // RFC3339 / ISO8601 나노초 파싱을 위한 DateFormatter
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZZZZZ"
            
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            // 디버깅을 위해 실제 날짜 문자열 출력
            print("🚨 Failed to parse date: \(dateStr)")
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Date string does not match expected format: \(dateStr)"
                )
            )
        }
        
        do {
            let response = try decoder.decode(Components.Schemas.ErrorResponse.self, from: jsonData)
            return response
        } catch {
            print("🚨 Decoding error: \(error)")
            print("Raw JSON: \(jsonString)")
            throw error
        }
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
