//
//  TargetConfiguration.swift
//  ProjectDescriptionHelpers
//
//  Created by 김지수 on 8/17/24.
//

import ProjectDescription

public enum TargetName: String {
    case devApp = "DevApp"
    case prodApp = "ProdApp"
    case coreKit = "CoreKit"
    case networkKit = "NetworkKit"
    case designSystemKit = "DesignSystemKit"
    case componentsKit = "ComponentsKit"
    case main = "Main"
}

extension TargetName {
    var projectPath: ProjectPath {
        switch self {
        case .devApp, .prodApp:
            return .app
        case .coreKit, .networkKit:
            return .core
        case .designSystemKit, .componentsKit:
            return .designSystem
        case .main:
            return .feature
        }
    }
    
    var name: String {
        return self.rawValue
    }
    
    var sources: String {
        return "\(self.rawValue)/Sources/**"
    }
    
    var resources: String {
        return "\(self.rawValue)/Resources/**"
    }
}

public enum ProjectPath: String {
    case app = "Projects/App"
    case core = "Projects/Core"
    case designSystem = "Projects/DesignSystem"
    case feature = "Projects/Features"
}
