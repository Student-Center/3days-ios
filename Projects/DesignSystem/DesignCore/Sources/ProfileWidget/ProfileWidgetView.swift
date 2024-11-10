//
//  ProfileWidgetView.swift
//  DesignCore
//
//  Created by 김지수 on 11/7/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit

public struct ProfileWidgetView: View {
    
    public let title: String
    public let bodyText: String
    public let titleColor: Color
    public let bodyColor: Color
    public let gradientColors: [Color]
    
    public init(
        title: String,
        bodyText: String,
        titleColor: Color,
        bodyColor: Color,
        gradientColors: [Color]
    ) {
        self.title = title
        self.bodyText = bodyText
        self.titleColor = titleColor
        self.bodyColor = bodyColor
        self.gradientColors = gradientColors
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            VStack {
                HStack {
                    Text(title)
                        .pretendard(weight: ._600, size: 22)
                        .foregroundStyle(titleColor)
                    Spacer()
                    Image(systemName: "plus.circle")
                }
                Spacer()
                ScrollView {
                    LeftAlignText(bodyText)
                        .typography(.regular_14)
                        .foregroundStyle(bodyColor)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.all, 20)
        }
    }
}
