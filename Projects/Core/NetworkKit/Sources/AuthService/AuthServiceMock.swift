//
//  AuthServiceMock.swift
//  NetworkKit
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import Model
import CoreKit

public class AuthServiceMock: AuthServiceProtocol {
    public init() {}
    
    public func requestSendSMS(phone: String) async throws -> SMSSendResponse {
        return SMSSendResponse(
            userType: .NEW,
            authCodeId: "abcd",
            phoneNumber: phone
        )
    }
    
    public func requestNewUserVerifyCode(
        _ request: SMSVerificationRequest
    ) async throws -> String {
        return "registerToken"
    }
    
    public func requestExistingUserVerifyCode(
        _ request: SMSVerificationRequest
    ) async throws -> ExistingUserVerificationResponse {
        return ExistingUserVerificationResponse(
            refreshToken: "refreshToken",
            accessToken: "accessToken"
        )
    }
}
