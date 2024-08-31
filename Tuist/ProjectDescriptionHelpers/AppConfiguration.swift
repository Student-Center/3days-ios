//
//  AppConfiguration.swift
//  ProjectDescriptionHelpers
//
//  Created by 김지수 on 8/17/24.
//

import ProjectDescription

public enum AppConfig {
    case dev
    case prod
}

public extension AppConfig {
    static let appVersion: SettingValue = "1.0.0"
    static let buildNumber: SettingValue = "1"
}

public extension AppConfig {
    var flag: String {
        switch self {
        case .dev: return "dev"
        case .prod: return "prod"
        }
    }
    
    var appName: String {
        return "three-days-\(self.flag)"
    }
    
    var appDisplayName: SettingValue {
        switch self {
        case .dev:
            return "3days-dev"
        case .prod:
            return "3days"
        }
    }
}
