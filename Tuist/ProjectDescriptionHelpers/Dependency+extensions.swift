//
//  Dependency+extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by 김지수 on 8/17/24.
//

import ProjectDescription

public enum ExternalDependency: String {
    case alamofire = "Alamofire"
    case nuke = "Nuke"
    case openapiGenerated = "OpenapiGenerated"
    
    var name: String {
        return self.rawValue
    }
}

/*
 고민중.
 case composableArchitecture = "ComposableArchitecture"
 case tcaCoordinators = "TCACoordinators"
 case kakaoSDK = "KakaoSDK"
 */
