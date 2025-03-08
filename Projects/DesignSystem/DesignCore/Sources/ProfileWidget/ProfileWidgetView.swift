//
//  ProfileWidgetView.swift
//  DesignCore
//
//  Created by 김지수 on 11/7/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit

public enum ProfileWidgetIconType {
    case add
    case edit
    
    var image: Image {
        switch self {
        case .add: DesignCore.Images.plusCircleFilled.image
        case .edit: DesignCore.Images.pencil1.image
        }
    }
}

public struct ProfileWidgetView: View {
    
    public let title: String
    public let bodyText: String
    public let titleColor: Color
    public let bodyColor: Color
    public let gradientColors: [Color]
    public var iconType: ProfileWidgetIconType?
    public let isDisabled: Bool
    
    public init(
        title: String,
        bodyText: String,
        titleColor: Color,
        bodyColor: Color,
        gradientColors: [Color],
        iconType: ProfileWidgetIconType? = nil,
        isDisabled: Bool = false
    ) {
        self.title = title
        self.bodyText = bodyText
        self.titleColor = titleColor
        self.bodyColor = bodyColor
        self.gradientColors = gradientColors
        self.iconType = iconType
        self.isDisabled = isDisabled
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
                    if let iconType {
                        iconType.image
                            .resizable()
                            .frame(width: 22, height: 22)
                    }
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
            
            if isDisabled {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white.opacity(0.45))
                
                DesignCore.Images.iconCheck.image
                    .resizable()
                    .frame(width: 64, height: 64)
            }
        }
    }
}
