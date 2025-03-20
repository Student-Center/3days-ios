//
//  ChatContainerView.swift
//  Chat
//
//  Created by 김지수 on 2/4/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct ChatContainerView: View {
    
    @StateObject var container: MVIContainer<ChatContainerIntent.Intentable, ChatContainerModel.Stateful>
    
    @State private var inputText: String = ""
    @State private var selectedCard: ChatCard?
    @Namespace private var namespace
    
    private var intent: ChatContainerIntent.Intentable { container.intent }
    private var state: ChatContainerModel.Stateful { container.model }
    
    public init(token: String? = TokenManager.accessToken) {
        let model = ChatContainerModel()
        let intent = ChatContainerIntent(
            model: model,
            input: .init(),
            customToken: token
        )
        let container = MVIContainer(
            intent: intent as ChatContainerIntent.Intentable,
            model: model as ChatContainerModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            ChatMessageListView(
                messageDataSource: state.messageDataSource,
                hasNextPage: state.hasNextPage,
                inputText: $inputText,
                sendAction: {
                    intent.sendMessage(inputText)
                    inputText = ""
                },
                nextPageAction: {
                    intent.requestNextPage(
                        cursor: state.messageDataSource.nextCursor
                    )
                },
                cardTapHandler: { card in
                    print(card)
                    selectedCard = card
                },
                namespace: namespace
            )
        }
        .sheet(
            item: $selectedCard,
            content: { card in
                CardFullScreenView(card: card, namespace: namespace)
        })
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        ZStack {
            ChatContainerView()
        }
    }
}
