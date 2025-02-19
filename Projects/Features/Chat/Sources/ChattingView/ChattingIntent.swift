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

//MARK: - Intent
class ChattingIntent {
    private weak var model: ChattingModelActionable?
    private let input: DataModel
    private let stompClient = StompClient.shared
    private var subscriptions = [AnyCancellable]()
    
    // MARK: Life cycle
    init(
        model: ChattingModelActionable,
        input: DataModel,
        customToken: String? = TokenManager.accessToken
    ) {
        self.input = input
        self.model = model
        stompClient.accessToken = customToken
    }
}

//MARK: - Intentable
extension ChattingIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        
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
    }
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
    
    func subscribeStomp() {
        
        stompClient.client.eventsUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self else { return }
                print("event", event)
                switch event {
                case let .connected(type):
                    if type == .toStomp {
                        stompClient.subscribe(channelId: "33333333-3333-3333-3333-333333333333")
                    }
                    model?.setSocketStatus(isConnected: true)
                case .disconnected(_):
                    model?.setSocketStatus(isConnected: false)
                case let .error(error):
                    model?.setSocketStatus(isConnected: false)
                    print("Error: \(error)")
                }
            }
            .store(in: &subscriptions)
        
        stompClient.client.messagesUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case let .text(message, messageId, destination, _):
                    let message = "\(Date().formatted()) [id: \(messageId), at: \(destination)]: \(message)"
                    model?.socketReceivedNewMessage(message: message)
                case let .data(data, messageId, destination, _):
                    let message = "Data message with id `\(messageId)` and binary length `\(data.count)` received at destination `\(destination)`"
                    model?.socketReceivedNewMessage(message: message)
                }
            }
            .store(in: &subscriptions)
        
        stompClient.client.receiptUpstream
            .sink { receiptId in
                print("SwiftStop: Receipt received: \(receiptId)")
            }
            .store(in: &subscriptions)
    }
}
