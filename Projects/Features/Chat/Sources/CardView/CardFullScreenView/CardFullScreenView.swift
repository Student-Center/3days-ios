//
//  CardFullScreenView.swift
//  Chat
//
//  Created by 김지수 on 3/18/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct CardFullScreenView: View {
    
    @StateObject var container: MVIContainer<CardFullScreenIntent.Intentable, CardFullScreenModel.Stateful>
    var namespace: Namespace.ID

    private var intent: CardFullScreenIntent.Intentable { container.intent }
    private var state: CardFullScreenModel.Stateful { container.model }
    private let card: ChatCard
    public init(card: ChatCard, namespace: Namespace.ID) {
        let model = CardFullScreenModel()
        let intent = CardFullScreenIntent(
            model: model,
            input: .init(card: card)
        )
        let container = MVIContainer(
            intent: intent as CardFullScreenIntent.Intentable,
            model: model as CardFullScreenModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self.card = card
        self._container = StateObject(wrappedValue: container)
        self.namespace = namespace
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Color.clear
                LinearGradient(
                    colors: [
                        card.color.cardColor.opacity(0),
                        card.color.cardColor
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            VStack {
                card.color.cardImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Device.width - 72)
                    .overlay {
                        ZStack {
                            VStack {
                                Text("첫 인사 보내기")
                                    .typography(.semibold_14)
                                    .foregroundStyle(DesignCore.Colors.pink500)
                                    .padding(.top, 22)
                                Spacer()
                            }
                            
                            Text(card.message)
                                .multilineTextAlignment(.center)
                                .pretendard(weight: ._400, size: 20)
                                .lineSpacing(10)
                                .foregroundStyle(DesignCore.Colors.grey500)
                        }
                    }
                
                Text("이미 보낸 카드는 수정할 수 없어요")
                    .typography(.regular_12)
                    .foregroundStyle(DesignCore.Colors.grey300)
            }
        }
        .navigationTitle(card.userType == .my ? "내가 보낸 카드" : "상대가 보낸 카드")
        .navigationTransition(
            .zoom(
                sourceID: card.id,
                in: namespace
            )
        )
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
        CardFullScreenView(card: .mock, namespace: Namespace.init().wrappedValue)
    }
}
