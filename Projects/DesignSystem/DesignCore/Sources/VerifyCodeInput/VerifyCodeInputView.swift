//
//  VerifyCodeInputView.swift
//  DesignCore
//
//  Created by 김지수 on 10/4/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct VerifyCodeInputView: View {
    
    @Binding var verifyCode: String
    @Binding var errorMessage: String?
    var verifyCodeMaxCount: Int
    @FocusState private var isTextFieldFocused: Bool
    let boxHeight: CGFloat
    let textColor: Color
    let borderWidth: CGFloat
    let borderColor: Color
    let backColor: Color
    let cornerRadius: CGFloat
    
    public init(
        verifyCode: Binding<String>,
        errorMessage: Binding<String?>,
        verifyCodeMaxCount: Int = 6,
        boxHeight: CGFloat = 72,
        textColor: Color = .black,
        borderWidth: CGFloat = 0,
        borderColor: Color = .white,
        backColor: Color = .white,
        cornerRadius: CGFloat = 10,
        focused: FocusState<Bool>
    ) {
        self._verifyCode = verifyCode
        self._errorMessage = errorMessage
        self.verifyCodeMaxCount = verifyCodeMaxCount
        self._isTextFieldFocused = focused
        self.boxHeight = boxHeight
        self.textColor = textColor
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.backColor = backColor
        self.cornerRadius = cornerRadius
    }
        
    public var body: some View {
        ZStack(alignment: .center) {
            textBoxHStackView
            clearTextFieldView
        }
    }
    
    private var textBoxHStackView: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< verifyCodeMaxCount, id: \.self) { index in
                let text = getCharFromString(index: index)
                getSingleTextBox(text: text)
                    .shadow(.default)
            }
        }
    }
    
    @ViewBuilder
    private func getSingleTextBox(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
                .background(backColor)
                .clipShape(
                    RoundedRectangle(cornerRadius: cornerRadius)
                )
            Text(text)
                .pretendard(weight: ._600, size: 32)
                .foregroundStyle(textColor)
        }
        .frame(height: boxHeight)
    }
    
    private var clearTextFieldView: some View {
        TextField("", text: $verifyCode)
            .focused($isTextFieldFocused)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .onChange(of: verifyCode) { oldValue, newValue in
                if newValue.count == 6 {
                    isTextFieldFocused = false
                }
            }
            .keyboardType(.numberPad)
            .onTapGesture {
                verifyCode = ""
                isTextFieldFocused = true
            }
    }
    
    private func getCharFromString(index: Int) -> String {
        if verifyCode == "" {
            return ""
        }
        
        if index >= verifyCode.count {
            return ""
        }
        let numArray = verifyCode.compactMap { Int(String($0)) }
        return String(numArray[index])
    }
}
