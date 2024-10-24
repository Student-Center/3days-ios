//
//  DreamPartnerJobView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct DreamPartnerJobView: View {
    
    @StateObject var container: MVIContainer<DreamPartnerJobIntent.Intentable, DreamPartnerJobModel.Stateful>
    
    private var intent: DreamPartnerJobIntent.Intentable { container.intent }
    private var state: DreamPartnerJobModel.Stateful { container.model }
    
    public init() {
        let model = DreamPartnerJobModel()
        let intent = DreamPartnerJobIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as DreamPartnerJobIntent.Intentable,
            model: model as DreamPartnerJobModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            ProfileInputTemplatedView(
                currentPage: 2,
                maxPage: 3,
                subMessage: "연인이 되었을 때의 모습을 상상해 보세요.",
                mainMessage: "상대는 어떤 직군이라면 좋을까요?",
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
        DreamPartnerJobView()
    }
}
