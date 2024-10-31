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

actor LoggingMiddleware {
    package init() {}
}

extension LoggingMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        // Copy body data for logging
        let (bodyForLogging, bodyForRequest) = try await copyBody(body)
        logRequest(request, bodyForLogging)
        
        do {
            let (response, responseBody) = try await next(request, bodyForRequest, baseURL)
            // Copy response body data for logging
            let (responseBodyForLogging, responseBodyForReturn) = try await copyBody(responseBody)
            logResponse(request, response, responseBodyForLogging)
            return (response, responseBodyForReturn)
        } catch {
            logError(request, error: error)
            throw error
        }
    }
    
    private func copyBody(_ body: HTTPBody?) async throws -> (Data?, HTTPBody?) {
        guard let body = body else { return (nil, nil) }
        
        if case .known(let length) = body.length {
            let data = try await Data(collecting: body, upTo: Int(length))
            return (data, HTTPBody(data))
        }
        return (nil, body)
    }
}

extension LoggingMiddleware {
    private func logRequest(_ request: HTTPRequest, _ bodyData: Data?) {
        print("")
        print("======================== 👉 Network Request Log 👈 ==========================")
        debugPrint("✅ [URL] : \(request.path?.removingPercentEncoding ?? "<nil>")")
        debugPrint("✅ [Method] : \(request.method)")
        debugPrint("✅ [Headers] : \(request.headerFields)")
        
        if let bodyData = bodyData,
           let bodyString = String(data: bodyData, encoding: .utf8)?.toPrettyPrintedString {
            debugPrint("✅ [Body] : \(bodyString)")
        } else {
            debugPrint("✅ [Body] : body 없음")
        }
        print("==============================================================================")
        print("")
    }
    
    private func logResponse(_ request: HTTPRequest, _ response: HTTPResponse, _ bodyData: Data?) {
        print("")
        print("======================== 👉 Network Response Log 👈 ========================")
        debugPrint("✅ [StatusCode] : \(response.status.code)")
        
        let statusCode = response.status.code
        switch statusCode {
        case 400..<500:
            debugPrint("🚨 클라이언트 오류")
        case 500..<600:
            debugPrint("🚨 서버 오류")
        default:
            break
        }
        
        if let bodyData = bodyData,
           let responseString = String(data: bodyData, encoding: .utf8)?.toPrettyPrintedString {
            debugPrint("✅ [Response] : \(responseString)")
        } else {
            debugPrint("✅ [Response] : 응답 없음")
        }
        print("============================================================================")
        print("")
    }
    
    private func logError(_ request: HTTPRequest, error: Error) {
        print("")
        print("======================== 👉 Network Response Log 👈 ========================")
        debugPrint("🚨 요청 실패")
        debugPrint("✅ [Error] : \(error.localizedDescription)")
        print("============================================================================")
        print("")
    }
}

extension String {
    var toPrettyPrintedString: String {
        guard let data = self.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return self
        }
        return prettyString
    }
}
