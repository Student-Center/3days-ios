//
//  Shadows.swift
//  DesignCore
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public enum ShadowType {
    case `default`
    case alert
}

fileprivate struct ShadowViewModifier: ViewModifier {
    let type: ShadowType
    
    fileprivate func body(content: Content) -> some View {
        switch type {
        case .default:
            content
                .shadow(
                    color: Color(hex: 0x000000).opacity(0.08),
                    radius: 8,
                    x: 0.0,
                    y: 4.0
                )
        case .alert:
            content
                .shadow(
                    color: Color(hex: 0xF2597F).opacity(0.08),
                    radius: 8,
                    x: 0.0,
                    y: 4.0
                )
        }
    }
}

extension View {
    public func shadow(_ type: ShadowType) -> some View {
        modifier(ShadowViewModifier(type: type))
    }
}
