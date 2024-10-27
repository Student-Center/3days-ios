//
//  CompanySearchResponse.swift
//  CommonKit
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

public struct CompanySearchResponse {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
