//
//  StompClient.swift
//  NetworkKit
//
//  Created by 김지수 on 2/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import SwiftStomp

public class StompClient {
    public static let shared = StompClient()
    private var stompClinet: SwiftStomp!
    
    private init() {
        let url = URL(string: "\(ServerType.current.socketBaseUrl)")!
        self.stompClinet = SwiftStomp(host: url)
        self.stompClinet.delegate = self
        self.stompClinet.autoReconnect = true
    }
    
    public func connect() {
        if !stompClinet.isConnected {
            print("연결시도!")
            stompClinet.connect()
        }
    }
}

extension StompClient: SwiftStompDelegate {
    public func onConnect(
        swiftStomp: SwiftStomp,
        connectType: StompConnectType
    ) {
        print(#function)
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
        print(#function)
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
