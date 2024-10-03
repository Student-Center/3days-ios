//
//  Navigation+Ext.swift
//  CoreKit
//
//  Created by 김지수 on 10/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

private struct NavigationViewModifier: ViewModifier {
    let showLeftBackButton: Bool
    
    func body(content: Content) -> some View {
        content
            .setNavigation(
                showLeftBackButton: showLeftBackButton
            )
        {
            AppCoordinator.shared.pop()
        }
    }
}

public extension View {
    func setNavigationWithPop() -> some View {
        return modifier(
            NavigationViewModifier(
                showLeftBackButton: true
            )
        )
    }
}

