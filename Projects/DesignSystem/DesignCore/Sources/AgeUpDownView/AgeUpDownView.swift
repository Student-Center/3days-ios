//
//  AgeUpDownView.swift
//  DesignCore
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public enum AgeUpDownType {
    case up
    case down
    
    var emoji: String {
        switch self {
        case .up: "👆"
        case .down: "👇"
        }
    }
    
    var text: String {
        switch self {
        case .up: "위"
        case .down: "아래"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .up: DesignCore.Colors.green50
        case .down: DesignCore.Colors.pink50
        }
    }
    
    var borderColor: Color {
        switch self {
        case .up: .init(hex: 0xA1BA91)
        case .down: .init(hex: 0xE6B1C4)
        }
    }
    
    var textColor: Color {
        switch self {
        case .up: DesignCore.Colors.green500
        case .down: DesignCore.Colors.pink500
        }
    }
}

public struct AgeUpDownView: View {
    
    let type: AgeUpDownType
    
    private var upperValue: String?
    private var lowerValue: String?
    private var showPicker: Bool
    
    public init(
        type: AgeUpDownType,
        upperValue: String?,
        lowerValue: String?,
        showPicker: Bool
    ) {
        self.type = type
        self.upperValue = upperValue
        self.lowerValue = lowerValue
        self.showPicker = showPicker
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            HStack {
                Text(type.emoji)
                Text("내 나이보다")
                Text(type.text)
                Text("로")
            }
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 4)
                    .stroke(
                        borderColor(),
                        lineWidth: 10
                    )
                    .fill(type.backgroundColor)
                    .shadow(.default)
                switch type {
                case .up:
                    Text(upperValue ?? "-")
                        .pretendard(weight: ._600, size: 36)
                        .foregroundStyle(type.textColor)
                case .down:
                    Text(lowerValue ?? "-")
                        .pretendard(weight: ._600, size: 36)
                        .foregroundStyle(type.textColor)
                }
            }
            .frame(width: 92, height: 62)
            .padding(.horizontal, 2)
            
            Text("살")
        }
        .padding(.horizontal, 8)
        .foregroundStyle(DesignCore.Colors.grey300)
        .typography(.semibold_18)
    }
    
    func borderColor() -> Color {
        return showPicker ? type.borderColor : .white
    }
}
