//
//  TokenManager.swift
//  NetworkKit
//
//  Created by 김지수 on 9/1/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation

public enum TokenManager {
    public static var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "accessToken")
        }
    }
    
    public static var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "refreshToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "refreshToken")
        }
    }
    
    public static var registerToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "registerToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "registerToken")
        }
    }
}
