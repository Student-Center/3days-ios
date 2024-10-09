//
//  AuthPhoneVerifyView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/4/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct AuthPhoneVerifyView: View {
    
    @StateObject private var container: MVIContainer<AuthPhoneVerifyIntent.Intentable, AuthPhoneVerifyModel.Stateful>
    @FocusState private var verifyTextFieldFocused: Bool
    
    private var intent: AuthPhoneVerifyIntent.Intentable { container.intent }
    private var state: AuthPhoneVerifyModel.Stateful { container.model }
    
    public init(_ smsResponse: SMSSendResponse) {
        let model = AuthPhoneVerifyModel()
        let intent = AuthPhoneVerifyIntent(
            model: model,
            input: .init(smsResponse: smsResponse)
        )
        let container = MVIContainer(
            intent: intent as AuthPhoneVerifyIntent.Intentable,
            model: model as AuthPhoneVerifyModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack(spacing: 30) {
            LeftAlignText("인증코드를 입력해주세요")
                .typography(.semibold_24)

            VerifyCodeInputView(
                verifyCode: $container.model.verifyCode,
                errorMessage: $container.model.errorMessage,
                focused: _verifyTextFieldFocused
            )
            .textContentType(.oneTimeCode)
            .onChange(of: verifyTextFieldFocused) {
                intent.onChangeFocusState(verifyTextFieldFocused)
            }
            .onChange(of: state.verifyTextFieldFocused) {
                verifyTextFieldFocused = state.verifyTextFieldFocused
            }
            
            Button(
                action: {
                    
                },
                label: {
                    Text("\(state.sentPhoneNumber) 로 코드 재전송")
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
            
            // only dev 인증 건너뛰기
            #if STAGING || DEBUG
            HStack {
                Spacer()
                Button("개발자 권력으로 건너뛰기") {
                    // pushNextView 열어주지 않고 dev에서만 캐스팅하여 사용
                    if let intent = intent as? AuthPhoneVerifyIntent {
                        let targetPath = intent.getNextPath(userType: .NEW)
                        intent.pushNextView(to: targetPath)
                    }
                }
                Spacer()
            }
            #endif
            
            Spacer()
        }
        .onChange(of: state.verifyCode) {
            intent.onChangeVerifyCode(code: state.verifyCode)
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
        .padding(.horizontal, 26)
        .padding(.top, 14)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        AuthPhoneVerifyView(
            .init(
                userType: .NEW,
                authCodeId: "",
                phoneNumber: ""
            )
        )
    }
}
