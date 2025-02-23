//
//  ChatInputView.swift
//  Chat
//
//  Created by 김지수 on 2/23/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct ChatInputContainerView: View {
    
    @Binding var inputText: String
    @State var textFieldSize: CGSize = .init()
    @FocusState var isTextFieldFocused
    
    var sendAction: () -> Void
    
    private var textFieldHeight: CGFloat {
        return textFieldSize.height
    }
    
    private let textInputViewMinHeight: CGFloat = 60
    private let textInputViewMaxHeight: CGFloat = 108
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            HStack(alignment: .bottom, spacing: 0) {
                ChatInputFieldView(
                    text: $inputText,
                    textFieldSize: $textFieldSize,
                    isTextFieldFocused: _isTextFieldFocused
                )
                
                Button {
                    sendAction()
                } label: {
                    if inputText.isEmpty {
                        DesignCore.Images.iconSend.image
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                    } else {
                        DesignCore.Images.iconSendFilled.image
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                    }
                }
                .disabled(inputText.isEmpty)
            }
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(hex: 0xF7F3F1))
            }
            .frame(
                maxHeight: textFieldSize.height < textInputViewMaxHeight ? nil : textInputViewMaxHeight,
                alignment: .bottom
            )
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
        .background(.clear)
    }
}

struct ChatInputFieldView: View {
    
    @Binding var text: String
    @Binding var textFieldSize: CGSize
    @FocusState var isTextFieldFocused

    var body: some View {
        TextField(
            "메시지 보내기",
            text: $text,
            axis: .vertical
        )
        .focused($isTextFieldFocused)
        .pretendard(
            weight: ._400,
            size: 16,
            lineHeight: 24
        )
        .foregroundStyle(Color(hex: 0x17171B))
        .padding(.vertical, 10)
        .padding(.leading, 20)
        .tint(DesignCore.Colors.grey500)
        .frame(minHeight: 60)
        .sizeGetter($textFieldSize)
    }
}
