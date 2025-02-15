//
//  StompClient.swift
//  NetworkKit
//
//  Created by 김지수 on 2/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import SwiftStomp

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
    private var stompClinet: SwiftStomp!
    
    private init() {
        let url = URL(string: "\(ServerType.current.socketBaseUrl)")!
        self.stompClinet = SwiftStomp(
            host: url,
            httpConnectionHeaders: [
                "Authorization": "Bearer TEMP_TOKEN !!"
            ]
        )
        self.stompClinet.delegate = self
        self.stompClinet.autoReconnect = true
        self.stompClinet.enableAutoPing()
    }
    
    public func connect() {
        if !stompClinet.isConnected {
            print("연결시도!")
            stompClinet.connect()
        }
    }
    
    public func sendMessage(_ message: String) {
        let message = MessageRequest(
            senderUserId: "user_id",
            messageContent: message,
            messageType: "TEXT"
        )
        stompClinet.send(body: message, to: "/app/channel/channed_id")
    }
}

extension StompClient: SwiftStompDelegate {
    public func onConnect(
        swiftStomp: SwiftStomp,
        connectType: StompConnectType
    ) {
        print("onConnect: \(connectType)")
        if connectType == .toStomp {
            let destination = "/channel/channed_id"
            swiftStomp.subscribe(
                to: destination,
                mode: .client
            )
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
