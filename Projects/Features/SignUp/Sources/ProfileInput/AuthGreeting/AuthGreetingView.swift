//
//  AuthGreetingView.swift
//  SignUp
//
//  Created by 김지수 on 10/5/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthGreetingView: View {
    
    @StateObject var container: MVIContainer<AuthGreetingIntent.Intentable, AuthGreetingModel.Stateful>
    
    private var intent: AuthGreetingIntent.Intentable { container.intent }
    private var state: AuthGreetingModel.Stateful { container.model }
    
    public init() {
        let model = AuthGreetingModel()
        let intent = AuthGreetingIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as AuthGreetingIntent.Intentable,
            model: model as AuthGreetingModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            Text("만나서 반가워요!\n당신이 어떤 사람인지 알려주세요.")
                .typography(.semibold_24)
                .multilineTextAlignment(.center)
                .foregroundStyle(DesignCore.Colors.grey500)
                .opacity(state.isAppeared ? 1.0 : 0.0)
                .offset(y: state.isAppeared ? 0 : -24)
            
            Spacer()
            
            CTAButton(title: "알려주러 가기") {
                AppCoordinator.shared.push(
                    .signUp(.authProfileGender)
                )
            }
            .padding(.horizontal, 24)
            .opacity(state.isAppeared ? 1.0 : 0.0)
            .offset(y: state.isAppeared ? 0 : -24)
            
            Spacer()
        }
        .animation(
            .easeInOut,
            value: state.isAppeared
        )
        .setNavigation(
            showLeftBackButton: false,
            handler: {}
        )
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea()
        .padding(.top, 155)
        .textureBackground()
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        AuthGreetingView()
    }
}
