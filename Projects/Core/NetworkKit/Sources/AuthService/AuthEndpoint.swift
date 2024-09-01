//
//  AuthEndpoint.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import CoreKit

public struct AuthEndpoint: Endpointable {
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
