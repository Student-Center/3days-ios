//
//  AuthEndpoint.swift
//  NetworkKit
//
//  Created by 김지수 on 8/25/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import Alamofire

public enum AuthEndpoint {
    case refreshToken
}

extension AuthEndpoint: EndpointType {
    
    public var method: HTTPMethod {
        switch self {
        case .refreshToken: return .post
        }
    }
    
    public var path: String {
        switch self {
        case .refreshToken: return "auth/refresh-token"
        }
    }
    
    public var parameters: Encodable? {
        switch self {
        case .refreshToken:
            if let refreshToken = TokenManager.refreshToken {
                return ["refreshToken": refreshToken]
            }
            return nil
        }
    }
    
    public var body: Encodable? {
        return nil
    }
}

struct TokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
