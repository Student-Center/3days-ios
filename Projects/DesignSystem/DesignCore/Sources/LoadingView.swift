//
//  LoadingView.swift
//  DesignCore
//
//  Created by 김지수 on 10/4/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

private struct FullScreenLoadingOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.2)
                ProgressView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }
}


private struct LoadingViewModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    FullScreenLoadingOverlay()
                }
            }
    }
}

public extension View {
    func setLoading(_ isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
}
