//
//  DreamPartnerDistanceView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import SignUpDomain

public struct DreamPartnerDistanceView: View {
    
    @StateObject var container: MVIContainer<DreamPartnerDistanceIntent.Intentable, DreamPartnerDistanceModel.Stateful>
    
    private var intent: DreamPartnerDistanceIntent.Intentable { container.intent }
    private var state: DreamPartnerDistanceModel.Stateful { container.model }
    
    public init() {
        let model = DreamPartnerDistanceModel()
        let intent = DreamPartnerDistanceIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as DreamPartnerDistanceIntent.Intentable,
            model: model as DreamPartnerDistanceModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            VStack {
                ProfileInputTemplatedView(
                    currentPage: 3,
                    maxPage: 3,
                    subMessage: "연인이 되었을 때의 모습을 상상해 보세요.",
                    mainMessage: "상대와의 거리는\n어느 정도가 좋을까요?"
                ) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("🏢 내 활동 지역")
                                .pretendard(weight: ._400, size: 14)
                            Text("용인, 강남")
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
                            buttonView(
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
                }
                
                Spacer()
            }
            
            CTABottomButton(title: "다음", isActive: state.isValidated) {
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
    
    @ViewBuilder
    func buttonView(
        text: String,
        isSelected: Bool,
        handler: @escaping () -> Void
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white, lineWidth: 5)
                .fill(
                    isSelected ?
                    LinearGradient(
                        colors: [
                            Color(hex: 0x93CAF8),
                            Color(hex: 0x76B6EB),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    : 
                    LinearGradient(
                        colors: [
                            DesignCore.Colors.blue50
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            Text(text)
                .typography(.medium_14)
                .foregroundStyle(isSelected ? .white : DesignCore.Colors.grey500)
        }
        .frame(height: 60)
        .shadow(.default)
        .onTapGesture {
            handler()
        }
    }
}

#Preview {
    NavigationView {
        DreamPartnerDistanceView()
    }
}
