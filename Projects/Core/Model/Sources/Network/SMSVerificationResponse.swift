//
//  SMSVerificationResponse.swift
//  NetworkKit
//
//  Created by 김지수 on 9/1/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation

public struct ExistingUserVerificationResponse {
    public let refreshToken: String
    public let accessToken: String
    
    public init(refreshToken: String, accessToken: String) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}
