//
//  AuthProfileGenderInputView.swift
//  SignUp
//
//  Created by 김지수 on 10/5/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthProfileGenderInputView: View {
    
    @StateObject var container: MVIContainer<AuthProfileGenderInputIntent.Intentable, AuthProfileGenderInputModel.Stateful>
    
    private var intent: AuthProfileGenderInputIntent.Intentable { container.intent }
    private var state: AuthProfileGenderInputModel.Stateful { container.model }
    
    public init() {
        let model = AuthProfileGenderInputModel()
        let intent = AuthProfileGenderInputIntent(
            model: model,
            externalData: .init()
        )
        let container = MVIContainer(
            intent: intent as AuthProfileGenderInputIntent.Intentable,
            model: model as AuthProfileGenderInputModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            ProfileInputTemplatedView(
                currentPage: 1,
                maxPage: 5,
                subMessage: "만나서 반가워요!",
                mainMessage: "당신의 성별은 무엇인가요?"
            ) {
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(GenderType.allCases, id: \.self) {  type in
                        if state.selectedGender == type {
                            type.selectedImage
                                .resizable()
                                .frame(width: 130, height: 130)
                        } else {
                            type.unselectedImage
                                .resizable()
                                .frame(width: 130, height: 130)
                                .onTapGesture {
                                    intent.onTapGender(type)
                                }
                        }
                    }
                    Spacer()
                }
            }
            
            Spacer()
            
            CTABottomButton(
                title: "다음",
                isActive: state.selectedGender != nil
            ) {
                intent.onTapNextButton()
            }
        }
        .animation(
            .default,
            value: state.selectedGender
        )
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
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
        AuthProfileGenderInputView()
    }
}
