//
//  BackgroundTextureView.swift
//  DesignCore
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct BackgroundTextureView: View {
    public init() {}
    
    public var body: some View {
        DesignCore.Images.backgroundDefault.image!
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

fileprivate struct BackgroundTextureViewModifier: ViewModifier {
    fileprivate func body(content: Content) -> some View {
        content
            .background {
                DesignCore.Images.backgroundDefault.image!
                    .resizable()
                    .frame(
                        width: Device.width,
                        height: Device.height
                    )
                    .ignoresSafeArea()
            }
    }
}

extension View {
    public func textureBackground() -> some View {
        modifier(BackgroundTextureViewModifier())
    }
}
