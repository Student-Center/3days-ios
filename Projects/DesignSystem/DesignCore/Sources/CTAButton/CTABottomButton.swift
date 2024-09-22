//
//  CTABottomButton.swift
//  ComponentsKit
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct CTABottomButton<BackgroundStyle: ShapeStyle>: View {
    private let title: String
    private let backgroundStyle: BackgroundStyle
    private let titleColor: Color = .white
    private let isActive: Bool
    private let keyboardShown: Bool
    private var handler: () -> Void
    
    public init(
        title: String,
        backgroundStyle: BackgroundStyle = DesignCore.Colors.grey500,
        isActive: Bool = true,
        keyboardShown: Bool = false,
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundStyle = backgroundStyle
        self.isActive = isActive
        self.keyboardShown = keyboardShown
        self.handler = handler
    }
    
    private var buttonBackgroundColor: BackgroundStyle {
        if !isActive {
            return DesignCore.Colors.grey100 as! BackgroundStyle
        }
        return backgroundStyle
    }
    
    public var body: some View {
        Button(action: {
            handler()
        }, label: {
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .foregroundStyle(buttonBackgroundColor)
                        .frame(height: 68)
                        .cornerRadius(
                            20,
                            corners: [.topLeft, .topRight]
                        )
                    Text(title)
                        .foregroundStyle(titleColor)
                        .typography(.semibold_18)
                }
                Rectangle()
                    .foregroundStyle(buttonBackgroundColor)
                    .frame(height: keyboardShown ? 0 : Device.bottomInset)
            }
        })
        .disabled(!isActive)
        .ignoresSafeArea()
    }
}
