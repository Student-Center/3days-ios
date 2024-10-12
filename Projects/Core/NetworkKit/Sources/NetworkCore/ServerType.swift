//
//  ServerType.swift
//  NetworkKit
//
//  Created by 김지수 on 8/24/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import CoreKit

public enum ServerType: String {
    case dev // db 개발, api 개발
    case prod // db 상용, api 상용
    
    var baseURL: String {
        switch self {
        case .dev:
            return Secret.devBaseUrl
        case .prod:
            return Secret.prodBaseUrl
        }
    }
    
    static private(set) var serverType: ServerType = {
        if let appEnviroment = Bundle.main.infoDictionary?["App Enviroment"] as? String,
           let serverType = ServerType(rawValue: appEnviroment) {
            return serverType
        }
        #if STAGING || DEBUG
        return .dev
        #else
        return .prod
        #endif
    }()
    
    public static var current: ServerType {
        return serverType
    }
}
