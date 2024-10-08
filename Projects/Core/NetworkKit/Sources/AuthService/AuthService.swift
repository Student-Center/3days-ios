//
//  AuthService.swift
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

public enum AuthService: Endpointable {
    public static func requestSendSMS(phone: String) async throws -> SMSSendResponse {
        let response = try await client.requestVerification(
            headers: .init(X_hyphen_OS_hyphen_Type: .IOS),
            body: .json(.init(phoneNumber: phone))
        ).created.body.json
        
        return SMSSendResponse(
            userType: UserType(
                rawValue: response.userStatus?.rawValue ?? "NEW"
            ) ?? .NEW,
            authCodeId: response.authCodeId,
            phoneNumber: phone
        )
    }
    
    public static func requestNewUserVerifyCode(
        _ request: SMSVerificationRequest
    ) async throws -> String {
        let response = try await client.newUserVerifyCode(
            path: .init(authCodeId: request.verificationId),
            body: .json(.init(verificationCode: request.verificationCode))
        ).ok.body.json
        return response.registerToken
    }
    
    public static func requestExistingUserVerifyCode(
        _ request: SMSVerificationRequest
    ) async throws -> ExistingUserVerificationResponse {
        let response = try await client.existingUserVerifyCode(
            path: .init(authCodeId: request.verificationId),
            body: .json(.init(verificationCode: request.verificationCode))
        ).ok.body.json
        
        return ExistingUserVerificationResponse(
            refreshToken: response.refreshToken,
            accessToken: response.accessToken
        )
    }
}

//MARK: - AccessToken Refresh
extension AuthService {
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
