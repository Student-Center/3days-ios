//
//  AuthPhoneVerifyView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/1/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthPhoneVerifyView: View {
    
    @State var verifyCode = ""
    @State var errorMessage: String? = "에러에여"
    @FocusState private var verifyTextFieldFocused: Bool
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 30) {
            LeftAlignText("인증코드를 입력해주세요")
                .typography(.semibold_24)
            
            VerifyCodeInputView(
                verifyCode: $verifyCode,
                errorMessage: $errorMessage,
                focused: _verifyTextFieldFocused
            )
            
            Button(
                action: {
                    
                },
                label: {
                    Text("010-1234-1234로 코드 재전송")
                        .typography(.regular_14)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(
                                    Color(
                                        hex: 0x454545,
                                        opacity: 0.06
                                    )
                                )
                        }
                }
            )
            .tint(DesignCore.Colors.grey300)
            
            Spacer()
        }
        .onChange(of: verifyCode) {
            if verifyCode.count == 6 {
                AppCoordinator.shared.push(.signUp(.authAgreement))
            }
        }
        .onAppear {
            verifyTextFieldFocused = true
        }
        .ignoresSafeArea(.all)
        .padding(.horizontal, 26)
        .padding(.top, 14)
        .textureBackground()
        .setNavigation {
            AppCoordinator.shared.pop()
        }
    }
}

#Preview {
    NavigationView {
        AuthPhoneVerifyView()
    }
}

public struct VerifyCodeInputView: View {
    
    @Binding var verifyCode: String
    @Binding var errorMessage: String?
    var verifyCodeMaxCount: Int
    @FocusState private var isTextFieldFocused: Bool
    
    public init(
        verifyCode: Binding<String>,
        errorMessage: Binding<String?>,
        verifyCodeMaxCount: Int = 6,
        focused: FocusState<Bool>
    ) {
        self._verifyCode = verifyCode
        self._errorMessage = errorMessage
        self.verifyCodeMaxCount = verifyCodeMaxCount
        self._isTextFieldFocused = focused
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
            }
        }
    }
    
    @ViewBuilder
    private func getSingleTextBox(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(text)
                .pretendard(weight: ._600, size: 32)
        }
        .frame(height: 72)
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
        if index >= verifyCode.count {
            return ""
        }
        let numArray = verifyCode.compactMap { Int(String($0)) }
        return String(numArray[index])
    }
}
