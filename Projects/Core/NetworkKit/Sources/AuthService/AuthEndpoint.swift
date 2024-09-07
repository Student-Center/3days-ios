//
//  AuthEndpoint.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import Model
import CoreKit

enum AuthEndpointError: Error {
    case emptyToken
    case tokenResponseNotValid
}

public enum AuthEndpoint: Endpointable {
    public static func requestSMSVerification(phone: String) async throws -> String? {
        let response = try await client.requestVerification(
            .init(body: .json(.init(phoneNumber: phone)))
        )
        let result = try response.created
        return try result.body.json.verificationId
    }
    
    public static func verifySMSCode(request: SMSVerificationRequest) async throws {
        let response = try await client.verifyCode(
            path: .init(
                verificationId: request.verificationId
            ),
            body: .json(.init(verificationCode: request.verificationCode)
            )
        )
        let result = try response.ok.body.json
        
        switch result {
        case .ExistingUserVerificationResponse(let response):
            AuthState.shared.updateAuthState(
                to: .loggedIn(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
            )
        case .NewUserVerificationResponse(let response):
            AuthState.shared.updateAuthState(
                to: .signUp(
                    registerToken: response.registerToken
                )
            )
        }
    }
}

//MARK: - AccessToken Refresh
extension AuthEndpoint {
    static func refreshAccessToken() async throws -> RefreshTokenResponse {
        guard let refreshToken = TokenManager.refreshToken else {
            throw AuthEndpointError.emptyToken
        }

        let response = try await client.refreshToken(
            body: .json(.init(refreshToken: refreshToken))
        )
        
        let result = try response.ok.body.json
        
        TokenManager.accessToken = result.accessToken
        TokenManager.refreshToken = result.refreshToken
        
        return RefreshTokenResponse(
            refreshToken: result.refreshToken,
            accessToken: result.accessToken
        )
    }
}
