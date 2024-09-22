//
//  TextInputView.swift
//  ComponentsKit
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct TextInput<Content>: View where Content: View {
    let placeholder: String
    let backgroundColor: Color
    let keyboardType: UIKeyboardType
    @ViewBuilder let leftView: () -> Content
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    var rightIcon: TextInputRightIconModel?
    
    public init(
        placeholder: String = "",
        backgroundColor: Color = .white,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        isFocused: FocusState<Bool> = .init(),
        @ViewBuilder leftView: @escaping () -> Content = { EmptyView() },
        rightIcon: TextInputRightIconModel? = nil
    ) {
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.keyboardType = keyboardType
        self._text = text
        self._isFocused = isFocused
        self.leftView = leftView
        self.rightIcon = rightIcon
    }
    
    public var body: some View {
        ZStack {
            Capsule()
                .inset(by: -1)
                .stroke(
                    DesignCore.Colors.grey100,
                    lineWidth: isFocused ? 1.0 : 0
                )
                .background(backgroundColor)
            
            HStack(spacing: 10) {
                leftView()
                TextField(
                    placeholder,
                    text: $text
                )
                .focused($isFocused)
                .keyboardType(keyboardType)
                .tint(DesignCore.Colors.grey500)
                .foregroundStyle(DesignCore.Colors.grey500)
                .typography(.medium_16)
                
                if let rightIcon {
                    ZStack {
                        Circle()
                            .foregroundStyle(
                                rightIcon.backgroundColor.opacity(0.15)
                            )
                        rightIcon.icon
                    }
                    .frame(width: 36, height: 36)
                }
            }
            .padding(.leading, 24)
            .padding(.trailing, 12)
        }
        .frame(height: 60)
        .containerShape(Capsule())
        .shadow(.default)
    }
}

public struct TextInputRightIconModel {
    let icon: Image
    let backgroundColor: Color
    
    public init(
        icon: Image,
        backgroundColor: Color
    ) {
        self.icon = icon
        self.backgroundColor = backgroundColor
    }
}
