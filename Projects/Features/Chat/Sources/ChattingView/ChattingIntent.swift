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
        stompClient.socketConnectionStatus
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self else { return }
                print("event", event)
                switch event {
                case .connected:
                    print("connected")
                    stompClient.subscribe(channelId: "33333333-3333-3333-3333-333333333333")
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
}
