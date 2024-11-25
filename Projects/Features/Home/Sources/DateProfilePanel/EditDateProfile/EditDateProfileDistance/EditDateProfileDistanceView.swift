//
//  EditDateProfileDistanceView.swift
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

public struct EditDateProfileDistanceView: View {
    
    @StateObject var container: MVIContainer<EditDateProfileDistanceIntent.Intentable, EditDateProfileDistanceModel.Stateful>
     
    private var intent: EditDateProfileDistanceIntent.Intentable { container.intent }
    private var state: EditDateProfileDistanceModel.Stateful { container.model }
    
    public init(_ userInfo: UserInfo) {
        let model = EditDateProfileDistanceModel()
        let intent = EditDateProfileDistanceIntent(
            model: model,
            input: .init(userInfo: userInfo)
        )
        let container = MVIContainer(
            intent: intent as EditDateProfileDistanceIntent.Intentable,
            model: model as EditDateProfileDistanceModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            VStack(spacing: 12) {
                HStack {
                    Text("🏢 내 활동 지역")
                        .pretendard(weight: ._400, size: 14)
                    Text(state.myRegionString)
                        .typography(.semibold_14)
                }
                .foregroundStyle(DesignCore.Colors.grey400)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background {
                    Capsule()
                        .inset(by: 1)
                        .stroke(Color(hex: 0xEDE9C1), lineWidth: 2)
                        .fill(DesignCore.Colors.yellow50)
                }
                .padding(.bottom, 10)
                
                ForEach(DreamPartnerDistanceType.allCases, id: \.self) { type in
                    HorizontalButtonView(
                        text: type.description,
                        isSelected: state.selectedDistanceType == type
                    ) {
                        withAnimation {
                            intent.onTapDistanceType(type)
                        }
                    }
                }
                .animation(.default, value: state.selectedDistanceType)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 28)
            Spacer()
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
        .navigationTitle("선호 거리 수정")
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
        EditDateProfileDistanceView(.mock)
    }
}
