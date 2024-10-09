//
//  Dependency+extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by 김지수 on 8/17/24.
//

import ProjectDescription

public enum ExternalDependency: String {
    case nuke = "Nuke"
    case openapiGenerated = "OpenapiGenerated"
    
    var name: String {
        return self.rawValue
    }
}
