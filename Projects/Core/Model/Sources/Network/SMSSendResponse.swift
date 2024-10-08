//
//  SMSSendResponse.swift
//  CoreKit
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

public enum UserType: String {
    case NEW = "NEW"
    case EXISTING = "EXISTING"
}

public struct SMSSendResponse {
    public let userType: UserType
    public let authCodeId: String
    public let phoneNumber: String
    
    public init(
        userType: UserType,
        authCodeId: String,
        phoneNumber: String
    ) {
        self.userType = userType
        self.authCodeId = authCodeId
        self.phoneNumber = phoneNumber
    }
}
