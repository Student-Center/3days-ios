//
//  TokenManager.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation

internal enum TokenManager {
    static var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "accessToken")
        }
    }
    
    static var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "refreshToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "refreshToken")
        }
    }
}
