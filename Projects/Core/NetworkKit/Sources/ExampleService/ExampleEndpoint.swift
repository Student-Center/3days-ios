//
//  ExampleEndpoint.swift
//  NetworkKit
//
//  Created by 김지수 on 8/24/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import Foundation
import Alamofire

public enum ExampleEndpoint {
    case example
}

extension ExampleEndpoint: EndpointType {
    
    
    public var method: HTTPMethod {
        switch self {
        case .example: return .get
        }
    }
    
    public var path: String {
        switch self {
        case .example: return "api/"
        }
    }
    
    public var parameters: Encodable? {
        return nil
    }
    
    public var body: Encodable? {
        return nil
    }
}
