//
//  AuthAgreementView.swift
//  SignUp
//
//  Created by 김지수 on 10/5/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthAgreementView: View {
    
    @StateObject var container: MVIContainer<AuthAgreementIntent.Intentable, AuthAgreementModel.Stateful>
    
    private var intent: AuthAgreementIntent.Intentable { container.intent }
    private var state: AuthAgreementModel.Stateful { container.model }
    
    public init() {
        let model = AuthAgreementModel()
        let intent = AuthAgreementIntent(
            model: model,
            externalData: .init()
        )
        let container = MVIContainer(
            intent: intent as AuthAgreementIntent.Intentable,
            model: model as AuthAgreementModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack(spacing: 30) {
            LeftAlignText("인증이 완료되었어요!\n이용약관에 동의하면 끝나요")
                .typography(.semibold_24)
                .padding(.horizontal, 26)
            
            Text("TBD")
                .typography(.semibold_24)
                .foregroundStyle(DesignCore.Colors.grey200)
            
            Spacer()
            
            CTABottomButton(title: "다음") {
                intent.onTapNextButton()
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
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
        AuthAgreementView()
    }
}
