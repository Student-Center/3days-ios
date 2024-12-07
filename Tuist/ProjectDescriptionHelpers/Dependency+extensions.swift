//
//  Dependency+extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by 김지수 on 8/17/24.
//

import ProjectDescription

public enum ExternalDependency: String {
    case nuke = "NukeUI"
    case openapiGenerated = "OpenapiGenerated"
    case navigationTransitions = "NavigationTransitions"
    case toast = "Toast"
    
    var name: String {
        return self.rawValue
    }
}
