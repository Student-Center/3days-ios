//
//  ErrorModel.swift
//  CoreKit
//
//  Created by 김지수 on 10/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

public struct ErrorModel {
    public let title: String?
    public let message: String?
    
    public init(
        title: String?,
        message: String?
    ) {
        self.title = title
        self.message = message
    }
}

