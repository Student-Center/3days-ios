//
//  NavigationBar.swift
//  DesignCore
//
//  Created by 김지수 on 10/1/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

private struct NavigationBarViewModifier: ViewModifier {
    var handler: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        handler()
                    } label: {
                        DesignCore.Images.leftArrow.image
                    }
                    
                }
            }
    }
}

public extension View {
    func setNavigation(handler: @escaping () -> Void) -> some View {
        return modifier(NavigationBarViewModifier(handler: handler))
    }
}
