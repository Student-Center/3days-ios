//
//  StompClient.swift
//  NetworkKit
//
//  Created by 김지수 on 2/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import Model
import Combine
import SwiftStomp
import CoreKit

public class StompClient {
    public static let shared = StompClient()
    private var client: SwiftStomp!
    public var accessToken: String? = TokenManager.accessToken
    
    public var socketConnectionStatus = CurrentValueSubject<SocketConnectionStatus, Never>(.disconnected)
    public var onMessageReceived = PassthroughSubject<Message, Never>()
    private var subscriptions = [AnyCancellable]()
    
    private init() {
        let url = URL(string: "\(ServerType.current.socketBaseUrl)")!
        self.client = SwiftStomp(
            host: url,
            httpConnectionHeaders: [
                "Authorization": "Bearer \(accessToken ?? "")"
            ]
        )
        self.client.autoReconnect = true
        self.client.enableAutoPing()
        subscribeStomp()
    }
    
    public func connect() {
        if !client.isConnected {
            socketConnectionStatus.send(.connecting)
            client.connect()
        }
    }
    
    public func sendMessage(request: ChatSocketMessageRequest, channelId: String) {
        client.send(body: request, to: "/app/channel/\(channelId)")
    }
    
    public func subscribe(channelId: String) {
        let destination = "/channel/\(channelId)"
        client.subscribe(
            to: destination,
            mode: .client
        )
    }
}

extension StompClient {
    func subscribeStomp() {
        client.eventsUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self else { return }
                print("event", event)
                switch event {
                case .connected(_):
                    socketConnectionStatus.send(.connected)
                case .disconnected(_):
                    socketConnectionStatus.send(.disconnected)
                case let .error(error):
                    print(error)
                    socketConnectionStatus.send(.disconnected)
                }
            }
            .store(in: &subscriptions)
        
        client.messagesUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                if case let .text(message, messageId, destination, _) = message {
                    guard let response = decodeMessageToDto(message) else { return }
                    let messageModel = Message(from: response)
                    onMessageReceived.send(messageModel)
                }
            }
            .store(in: &subscriptions)
        
        client.receiptUpstream
            .sink { receiptId in
                print("SwiftStop: Receipt received: \(receiptId)")
            }
            .store(in: &subscriptions)
    }
    
    func decodeMessageToDto(_ rawMessage: String) -> ChatSocketResponse? {
        guard let jsonData = rawMessage.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(ChatSocketResponse.self, from: jsonData)
            return response
        } catch {
            print(error)
            return nil
        }
    }
}
