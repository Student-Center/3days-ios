//
//  HorizontalButtonView.swift
//  DesignCore
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct HorizontalButtonView: View {
    let text: String
    let isSelected: Bool
    let handler: () -> Void
    
    public init(
        text: String,
        isSelected: Bool,
        handler: @escaping () -> Void
    ) {
        self.text = text
        self.isSelected = isSelected
        self.handler = handler
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white, lineWidth: 5)
                .fill(
                    isSelected ?
                    LinearGradient(
                        colors: [
                            Color(hex: 0x93CAF8),
                            Color(hex: 0x76B6EB),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    :
                    LinearGradient(
                        colors: [
                            DesignCore.Colors.blue50
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            Text(text)
                .typography(.medium_14)
                .foregroundStyle(isSelected ? .white : DesignCore.Colors.grey500)
        }
        .frame(height: 60)
        .shadow(.default)
        .onTapGesture {
            handler()
        }
    }
}
