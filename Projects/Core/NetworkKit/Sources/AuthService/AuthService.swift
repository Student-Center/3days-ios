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
import OpenapiGenerated

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
    func requestSignUp(
        domain: SignUpFormDomain
    ) async throws -> Components.Schemas.RegisterUserResponse
}

//MARK: - Service
public final class AuthService {
    public static let shared = AuthService()
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
    
    public func requestSignUp(
        domain: SignUpFormDomain
    ) async throws -> Components.Schemas.RegisterUserResponse {
        guard let body = domain.toDto else {
            print("⚠️ 도메인 -> DTO 변환 실패!")
            throw NetworkError.dtoConversionFailed
        }
        
        let response = try await client.registerUser(
            headers: .init(
                X_hyphen_Register_hyphen_Token: domain.registerToken
            ),
            body: .json(body)
        )
        return try response.created.body.json
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
