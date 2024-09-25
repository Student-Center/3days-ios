//
//  BackgroundTextureView.swift
//  DesignCore
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct BackgroundTextureView: View {
    let color: Color
    
    public init(_ color: Color) {
        self.color = color
    }
    
    public var body: some View {
        ZStack {
            color
            DesignCore.Images.bgTexture.image
                .resizable()
                .frame(
                    width: Device.width,
                    height: Device.height
                )
                .aspectRatio(contentMode: .fill)
        }
        .ignoresSafeArea()
    }
}

private struct BackgroundTextureViewModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background {
                BackgroundTextureView(color)
            }
    }
}

extension View {
    public func textureBackground(_ color: Color = .init(hex: 0xF5F1EE)) -> some View {
        modifier(BackgroundTextureViewModifier(color: color))
    }
}
