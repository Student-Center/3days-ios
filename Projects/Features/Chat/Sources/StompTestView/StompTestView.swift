//
//  StompTestView.swift
//  Chat
//
//  Created by 김지수 on 1/28/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import NetworkKit

public struct StompTestView: View {
    
    @StateObject var container: MVIContainer<StompTestIntent.Intentable, StompTestModel.Stateful>
    
    private var intent: StompTestIntent.Intentable { container.intent }
    private var state: StompTestModel.Stateful { container.model }
    
    @State var inputText: String = ""
    @State var customToken: String = ""
    
    public init() {
        let model = StompTestModel()
        let intent = StompTestIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as StompTestIntent.Intentable,
            model: model as StompTestModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
                Text("Welcome to STOMP TestBed")
                    .typography(.semibold_20)
            if state.authToken == nil {
                Divider()
                
                Text("접속할 테스트 번호 입력\n테스트 인증 번호만 가능합니다.")
                    .typography(.medium_16)
                    .multilineTextAlignment(.center)
                
                TextField("010-0000-0001", text: $inputText)
                    .multilineTextAlignment(.center)
                
                Button("테스트 번호로 인증") {
                    intent.onTapVerifyButton(phone: inputText)
                }
                .buttonStyle(BorderedButtonStyle())
                .disabled(inputText.count < 5)
                
                Divider()
                
                Text("엑세스 토큰 바로 입력해 접속하기\n유효한 토큰만 가능합니다.")
                    .typography(.medium_16)
                    .multilineTextAlignment(.center)
                
                TextField("Bearer accessToken", text: $customToken)
                    .multilineTextAlignment(.center)
                    .typography(.medium_16)
                
                Button("토큰으로 바로 접속") {
                    intent.onTapCustomToken(token: customToken)
                }
                .buttonStyle(BorderedButtonStyle())
                .disabled(customToken.count < 5)
            }
            
            if let token = state.authToken {
                Text(token)
                    .typography(.medium_16)
                    .multilineTextAlignment(.center)
                    .typography(.medium_16)
                
                Button("이 토큰으로 접속!") {
                    AppCoordinator.shared.push(.chat(.chat(customToken: token)))
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        StompTestView()
    }
}
