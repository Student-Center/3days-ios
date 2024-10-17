//
//  AuthJobView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/17/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthJobView: View {
    
    @StateObject var container: MVIContainer<AuthJobIntent.Intentable, AuthJobModel.Stateful>
    
    private var intent: AuthJobIntent.Intentable { container.intent }
    private var state: AuthJobModel.Stateful { container.model }
    
    public init() {
        let model = AuthJobModel()
        let intent = AuthJobIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as AuthJobIntent.Intentable,
            model: model as AuthJobModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            ProfileInputTemplatedView(
                currentPage: 4,
                maxPage: 5,
                subMessage: "좋아요, 조금만 더 알려주세요!",
                mainMessage: "재직 중인 회사에서\n당신의 직군은 무엇인가요?",
                hPadding: 0
            ) {
                JobSelectionView(selected: state.selectedJobArray) { job in
                    intent.onTapJobOccupation(
                        selectedAllJobs: state.selectedJobArray,
                        selectedJob: job
                    )
                }
            }
            .padding(.bottom, 90)

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
        .ignoresSafeArea(.keyboard)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        AuthJobView()
    }
}
