//
//  CTAButton.swift
//  DesignCore
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct CTAButton<BackgroundStyle: ShapeStyle>: View {
    private let title: String
    private let backgroundStyle: BackgroundStyle
    private let titleColor: Color = .white
    private let isActive: Bool
    private var handler: () -> Void
    
    public init(
        title: String,
        backgroundStyle: BackgroundStyle = DesignCore.Colors.grey500,
        isActive: Bool = true,
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundStyle = backgroundStyle
        self.isActive = isActive
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
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Text(title)
                        .foregroundStyle(titleColor)
                        .typography(.medium_18)
                }
            }
        })
        .disabled(!isActive)
        .frame(height: 60)
    }
}
