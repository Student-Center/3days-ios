//
//  AuthNameInputView.swift
//  SignUp
//
//  Created by 김지수 on 10/7/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct AuthNameInputView: View {
    
    @StateObject var container: MVIContainer<AuthNameInputIntent.Intentable, AuthNameInputModel.Stateful>
    
    private var intent: AuthNameInputIntent.Intentable { container.intent }
    private var state: AuthNameInputModel.Stateful { container.model }
    
    @State var inputText = String()
    
    public init(_ input: SignUpFormDomain) {
        let model = AuthNameInputModel()
        let intent = AuthNameInputIntent(
            model: model,
            input: .init(input: input)
        )
        let container = MVIContainer(
            intent: intent as AuthNameInputIntent.Intentable,
            model: model as AuthNameInputModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    @ViewBuilder
    var backgroundView: some View {
        ZStack {
            DesignCore.Images.namePaper.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 72)
            DesignCore.Images.pencil.image
                .resizable()
                .frame(width: 68, height: 68)
                .offset(x: 100, y: 12)
        }
    }
    
    public var body: some View {
        VStack(spacing: 44) {
            VStack(spacing: 0) {
                Text("이제 마지막이에요.")
                    .typography(.regular_14)
                    .foregroundStyle(DesignCore.Colors.grey200)
                Text("당신의 이름은 무엇인가요?")
                    .typography(.semibold_24)
                    .foregroundStyle(DesignCore.Colors.grey500)
            }
            
            ZStack {
                backgroundView
                TextField(
                    "김위브",
                    text: $inputText
                )
                .flatTextFieldOption(keyboardType: .namePhonePad)
                .multilineTextAlignment(.center)
                .pretendard(weight: ._400, size: 28)
                .foregroundStyle(DesignCore.Colors.grey500)
                .offset(y: -4)
                .onChange(of: inputText) {
                    intent.onChangeInputText(text: inputText)
                }
                .onChange(of: state.inputText) {
                    inputText = state.inputText
                }
            }
            
            Spacer()
            
            CTABottomButton(
                title: "다음",
                backgroundStyle: LinearGradient.gradientA,
                isActive: state.inputText.count >= 2
            ) {
                intent.onTapNextButton(state: state)
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
        .padding(.top, 10)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        AuthNameInputView(.mock)
    }
}
