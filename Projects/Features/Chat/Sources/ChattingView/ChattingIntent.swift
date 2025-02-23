//
//  ChattingIntent.swift
//  Chat
//
//  Created by 김지수 on 2/4/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import Combine
import CommonKit
import CoreKit
import NetworkKit
import Model

//MARK: - Intent
class ChattingIntent {
    private weak var model: ChattingModelActionable?
    private let input: DataModel
    private let stompClient = StompClient.shared
    private var subscriptions = [AnyCancellable]()
    private let channelId: String = "33333333-3333-3333-3333-333333333333"
    private let tempUserId: String = "11111111-1111-1111-1111-111111111111"
    private let chatService: ChatServiceProtocol
    
    // MARK: Life cycle
    init(
        model: ChattingModelActionable,
        input: DataModel,
        customToken: String? = TokenManager.accessToken,
        chatService: ChatServiceProtocol = ChatService.shared
    ) {
        self.input = input
        self.model = model
        self.chatService = chatService
        stompClient.accessToken = customToken
        TokenManager.userId = tempUserId
    }
}

//MARK: - Intentable
extension ChattingIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        func sendMessage(_ message: String)
        func requestNextPage(cursor: String?)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension ChattingIntent: ChattingIntent.Intentable {
    // default
    func onAppear() {
        print("onAppear, 연결시도")
        subscribeStomp()
        stompClient.connect()
        requestMessageList()
    }
    
    func task() async {}
    
    // content
    func sendMessage(_ message: String) {
        let requestBody = ChatSocketMessageRequest(
            senderUserId: tempUserId,
            messageContent: message,
            messageType: "TEXT"
        )
        stompClient.sendMessage(
            request: requestBody,
            channelId: channelId
        )
    }
    
    func onTapNextButton() {}
    
    func subscribeStomp() {
        stompClient.socketConnectionStatus
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .connected:
                    print("connected")
                    stompClient.subscribe(channelId: channelId)
                case .disconnected:
                    print("disconnected")
                default:
                    return
                }
            }
            .store(in: &subscriptions)
        
        stompClient.onMessageReceived
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                model?.socketReceivedNewMessage(message: message)
            }
            .store(in: &subscriptions)
    }
    
    func requestMessageList(nextCursor: String? = nil) {
        Task {
            do {
                let messageList = try await chatService.requestChannelMessage(
                    channeId: channelId,
                    nextCursor: nextCursor
                )
                if nextCursor == nil {
                    model?.setMessageList(message: messageList)
                } else {
                    model?.appendMessageList(message: messageList)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func requestNextPage(cursor: String?) {
        requestMessageList(nextCursor: cursor)
    }
}
