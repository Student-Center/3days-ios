//
//  FeatureTypes.swift
//  CoreKit
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

public enum FeatureType: CaseIterable {
    case designPreview
    case main
    
    public var name: String {
        switch self {
        case .designPreview: return "Design Preview"
        case .main: return "메인"
        }
    }
}
