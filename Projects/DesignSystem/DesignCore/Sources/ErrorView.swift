//
//  ErrorView.swift
//  DesignCore
//
//  Created by 김지수 on 10/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

private struct ErrorViewModifier: ViewModifier {
    var error: Error?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if let error {
                    errorView(error: error)
                }
            }
    }
    
    // Error View
    @ViewBuilder
    func errorView(error: Error) -> some View {
        ZStack {
            BackgroundTextureView(.init(hex: 0xF5F1EE))
            Text(error.localizedDescription)
                .typography(.semibold_20)
        }
    }
}

public extension View {
    func setErrorViewIfNeeded(error: Error?) -> some View {
        modifier(ErrorViewModifier(error: error))
    }
}
