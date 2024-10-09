//
//  AuthProfileAgeInputView.swift
//  SignUp
//
//  Created by 김지수 on 10/6/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthProfileAgeInputView: View {
    
    @FocusState var isFocused
    
    @StateObject var container: MVIContainer<AuthProfileAgeInputIntent.Intentable, AuthProfileAgeInputModel.Stateful>
    
    private var intent: AuthProfileAgeInputIntent.Intentable { container.intent }
    private var state: AuthProfileAgeInputModel.Stateful { container.model }
    
    public init() {
        let model = AuthProfileAgeInputModel()
        let intent = AuthProfileAgeInputIntent(
            model: model,
            input: .init(targetGender: .male)
        )
        let container = MVIContainer(
            intent: intent as AuthProfileAgeInputIntent.Intentable,
            model: model as AuthProfileAgeInputModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            ProfileInputTemplatedView(
                currentPage: 2,
                maxPage: 5,
                subMessage: "좋은 \(state.targetGender) 소개시켜 드릴께요!",
                mainMessage: "당신의 나이는 무엇인가요?"
            ) {
                VStack {
                    HStack {
                        VerifyCodeInputView(
                            verifyCode: $container.model.birthYear,
                            errorMessage: $container.model.errorMessage,
                            verifyCodeMaxCount: 4,
                            boxHeight: 92,
                            textColor: .black,
                            borderWidth: 4,
                            borderColor: .white,
                            backColor: DesignCore.Colors.yellow50,
                            cornerRadius: 20,
                            focused: _isFocused
                        )
                        .padding(.horizontal, 6)
                        .onChange(of: state.birthYear) {
                            intent.onYearChanged(
                                state.birthYear
                            )
                        }
                        .onChange(of: state.isFocused) {
                            isFocused = state.isFocused
                        }
                        .onChange(of: isFocused) {
                            intent.onFocusChanged(isFocused)
                        }
                        
                        VStack {
                            Spacer()
                            Text("년생")
                                .typography(.semibold_18)
                                .foregroundStyle(DesignCore.Colors.grey300)
                        }
                    }
                    .frame(height: 92)
                    
                    Button(action: {
                        
                    }, label: {
                        HStack(spacing: 4) {
                            DesignCore.Images.iconInformation.image
                            Text("가입 연령 확인하기")
                                .typography(.regular_14)
                                .foregroundStyle(DesignCore.Colors.grey200)
                        }
                    })
                    .padding(.top, 20)
                }
                .padding(.top, 8)
            }
            
            Spacer()
            
            CTABottomButton(
                title: "다음",
                isActive: state.isValidated
            ) {
                intent.onTapNextButton()
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea()
        .padding(.top, 10)
        .textureBackground()
        .setNavigation(showLeftBackButton: false) {
            
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        AuthProfileAgeInputView()
    }
}
