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
import OpenapiGenerated

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
    
    public func requestSignUp(domain: SignUpFormDomain) async throws -> Components.Schemas.RegisterUserResponse {
        return .init(
            accessToken: "accessToken",
            refreshToken: "refreshToken",
            expiresIn: 90
        )
    }
    
    public func requestMyUserInfo() async throws -> UserInfo {
        return .init(
            id: "",
            name: "",
            phone: "",
            profile: .init(
                gender: .female,
                birthYear: 0,
                companyId: nil,
                jobOccupation: "",
                locations: []
            ),
            dreamPartner: .init(
                upperBirthYear: nil,
                lowerBirthYear: nil,
                jobOccupations: [],
                distanceType: .anywhere,
                allowSameCompany: nil
            ),
            profileWidgets: []
        )
    }
}
