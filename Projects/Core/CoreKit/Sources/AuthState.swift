//
//  AuthState.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation

public enum AuthState {
    case none
    case login
    case loggedOut
}

public extension AuthState {
    static var changeHandler: ((AuthState) -> Void)?
    static func change(_ state: AuthState) {
        print("⚠️ Auth 상태 \(state)로 변경")
        if state == .loggedOut {
            TokenManager.accessToken = nil
            TokenManager.refreshToken = nil
        }
        changeHandler?(state)
    }
}
