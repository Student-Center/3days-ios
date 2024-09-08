//
//  RefreshTokenResponse.swift
//  Model
//
//  Created by 김지수 on 9/7/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation

public struct RefreshTokenResponse {
    public let refreshToken: String?
    public let accessToken: String?
    
    public init(
        refreshToken: String?,
        accessToken: String?
    ) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}
