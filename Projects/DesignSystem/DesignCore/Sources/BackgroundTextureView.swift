//
//  BackgroundTextureView.swift
//  DesignCore
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct BackgroundTextureView: View {
    public enum ColorType {
        case `default`
        case splashBrown
        case splashGreen
        case splashPurple
        case splashPink
        
        var color: Color {
            switch self {
            case .default: return Color(hex: 0xF5F1EE)
            case .splashBrown: return Color(hex: 0xE4DED7)
            case .splashGreen: return Color(hex: 0xDFE7D1)
            case .splashPurple: return Color(hex: 0xD7D7EA)
            case .splashPink: return Color(hex: 0xECDAE3)
            }
        }
    }
    
    let type: ColorType
    
    public init(_ type: ColorType) {
        self.type = type
    }
    
    public var body: some View {
        ZStack {
            type.color
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
    let colorType: BackgroundTextureView.ColorType
    
    func body(content: Content) -> some View {
        content
            .background {
                BackgroundTextureView(colorType)
            }
    }
}

extension View {
    public func textureBackground(_ type: BackgroundTextureView.ColorType) -> some View {
        modifier(BackgroundTextureViewModifier(colorType: type))
    }
}

#Preview {
    BackgroundTextureView(.splashGreen)
}
