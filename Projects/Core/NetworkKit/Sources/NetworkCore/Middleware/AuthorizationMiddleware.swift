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
import CoreKit

/// A client middleware that injects a value into the `Authorization` header field of the request.
struct AuthenticationMiddleware {
    /// The value for the `Authorization` header field.
    private var accessToken: String {
        guard let accessToken = TokenManager.accessToken else {
            print("❌ 잘못된 접근: 토큰이 비어있음.")
            return ""
        }
        return "Bearer \(accessToken)"
    }
}

extension AuthenticationMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        // Adds the `Authorization` header field with the provided value.
        request.headerFields[.authorization] = accessToken
        return try await next(request, body, baseURL)
    }
}
