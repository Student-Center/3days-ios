//
//  EditProfileCompanyView.swift
//  SignUp
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct EditProfileCompanyView: View {
    
    @StateObject var container: MVIContainer<EditProfileCompanyIntent.Intentable, EditProfileCompanyModel.Stateful>
    
    private var intent: EditProfileCompanyIntent.Intentable { container.intent }
    private var state: EditProfileCompanyModel.Stateful { container.model }
    
    public init() {
        let model = EditProfileCompanyModel()
        let intent = EditProfileCompanyIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as EditProfileCompanyIntent.Intentable,
            model: model as EditProfileCompanyModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            Text("Hello MVI")
        }
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
        EditProfileCompanyView()
    }
}

//ZStack {
//    VStack {
//        if let userInfo = state.userInfo {
//            HStack {
//                Text("💼 내 직군")
//                    .typography(.regular_12)
//                Text(userInfo.profile.jobOccupation)
//                    .pretendard(
//                        weight: ._600,
//                        size: 12
//                    )
//            }
//            .foregroundStyle(DesignCore.Colors.grey400)
//            .padding(.horizontal, 20)
//            .padding(.vertical, 10)
//            .background(
//                Capsule()
//                    .fill(DesignCore.Colors.yellow50)
//                    .stroke(
//                        Color(hex: 0xEDE9C1),
//                        lineWidth: 1
//                    )
//            )
//            .padding(.vertical, 10)
//        }
//        JobSelectionView(
//            selected: [state.singleSelectedJob].compactMap { $0 }
//        ) { job in
//            intent.onTapJobOccupation(
//                selectedJob: job
//            )
//        }
//        .padding(.bottom, 90)
//    }
//
//    CTABottomButton(
//        title: "다음",
//        isActive: state.isValidated
//    ) {
//        intent.onTapNextButton(state: state)
//    }
//}
//.task {
//    await intent.task()
//}
//.onAppear {
//    intent.onAppear()
//}
//.ignoresSafeArea(.keyboard)
//.navigationTitle("직군 수정")
//.textureBackground()
//.setPopNavigation {
//    AppCoordinator.shared.pop()
//}
//.setLoading(state.isLoading)
