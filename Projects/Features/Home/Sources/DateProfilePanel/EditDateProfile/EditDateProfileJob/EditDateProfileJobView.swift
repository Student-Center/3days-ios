//
//  EditDateProfileJobView.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct EditDateProfileJobView: View {
    
    @StateObject var container: MVIContainer<EditDateProfileJobIntent.Intentable, EditDateProfileJobModel.Stateful>
    
    private var intent: EditDateProfileJobIntent.Intentable { container.intent }
    private var state: EditDateProfileJobModel.Stateful { container.model }
    
    public init(_ userInfo: UserInfo) {
        let model = EditDateProfileJobModel()
        let intent = EditDateProfileJobIntent(
            model: model,
            input: .init(userInfo: userInfo)
        )
        let container = MVIContainer(
            intent: intent as EditDateProfileJobIntent.Intentable,
            model: model as EditDateProfileJobModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            VStack {
                JobSelectionView(
                    selected: state.selectedJobs
                ) { job in
                    intent.onTapJobOccupation(
                        selectedAllJobs: state.selectedJobs,
                        selectedJob: job
                    )
                }
                .padding(.bottom, 90)
            }

            CTABottomButton(
                title: "다음",
                isActive: state.isValidated
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
        .ignoresSafeArea(.keyboard)
        .navigationTitle("선호 직군 수정")
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        EditDateProfileJobView(.mock)
    }
}
