//
//  StompClient.swift
//  NetworkKit
//
//  Created by 김지수 on 2/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import SwiftStomp
import CoreKit

struct MessageRequest: Codable {
    let senderUserId: String
    let messageContent: String
    let messageType: String
    
    init(senderUserId: String, messageContent: String, messageType: String) {
        self.senderUserId = senderUserId
        self.messageContent = messageContent
        self.messageType = messageType
    }
}

public class StompClient {
    public static let shared = StompClient()
    public var client: SwiftStomp!
    public var accessToken: String? = TokenManager.accessToken
    
    private init() {
        let url = URL(string: "\(ServerType.current.socketBaseUrl)")!
        self.client = SwiftStomp(
            host: url,
            httpConnectionHeaders: [
                "Authorization": "Bearer \(accessToken ?? "")"
            ]
        )
        self.client.delegate = self
        self.client.autoReconnect = true
        self.client.enableAutoPing()
    }
    
    public func connect() {
        if !client.isConnected {
            print("연결시도!")
            client.connect()
        }
    }
    
    public func sendMessage(_ message: String) {
        let message = MessageRequest(
            senderUserId: "user_id",
            messageContent: message,
            messageType: "TEXT"
        )
        client.send(body: message, to: "/app/channel/channed_id")
    }
    
    public func subscribe(channelId: String) {
        let destination = "/channel/\(channelId)"
        client.subscribe(
            to: destination,
            mode: .client
        )
    }
}

extension StompClient: SwiftStompDelegate {
    public func onConnect(
        swiftStomp: SwiftStomp,
        connectType: StompConnectType
    ) {
        print("onConnect: \(connectType)")
        if connectType == .toStomp {

        }
    }
    
    public func onDisconnect(
        swiftStomp: SwiftStomp,
        disconnectType: StompDisconnectType
    ) {
        print(#function)
        print("⚠️ onDisconnect:", disconnectType)
    }
    
    public func onMessageReceived(
        swiftStomp: SwiftStomp,
        message: Any?,
        messageId: String,
        destination: String,
        headers: [String : String]
    ) {
        print("messageReceived", message)
    }
    
    public func onReceipt(
        swiftStomp: SwiftStomp,
        receiptId: String
    ) {
        print(#function)
    }
    
    public func onError(
        swiftStomp: SwiftStomp,
        briefDescription: String,
        fullDescription: String?,
        receiptId: String?,
        type: StompErrorType
    ) {
        print(#function)
        print("⚠️ onError:", fullDescription ?? "")
    }
}
