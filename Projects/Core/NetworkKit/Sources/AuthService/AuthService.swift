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

//MARK: - Service Protocol
public protocol AuthServiceProtocol {
    func requestSendSMS(phone: String) async throws -> SMSSendResponse
    func requestNewUserVerifyCode(
        _ request: SMSVerificationRequest
    ) async throws -> String
    func requestExistingUserVerifyCode(
        _ request: SMSVerificationRequest
    ) async throws -> ExistingUserVerificationResponse
}

//MARK: - Service
public final class AuthService {
    public static var shared = AuthService()
    private init() {}
}

extension AuthService: AuthServiceProtocol {
    public func requestSendSMS(phone: String) async throws -> SMSSendResponse {
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
    
    public func requestNewUserVerifyCode(
        _ request: SMSVerificationRequest
    ) async throws -> String {
        let response = try await client.newUserVerifyCode(
            path: .init(authCodeId: request.verificationId),
            body: .json(.init(verificationCode: request.verificationCode))
        ).ok.body.json
        return response.registerToken
    }
    
    public func requestExistingUserVerifyCode(
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
    public func refreshAccessToken() async throws -> RefreshTokenResponse {
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
