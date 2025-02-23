//
//  ChatSocketRequest.swift
//  Model
//
//  Created by 김지수 on 2/22/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation

public struct ChatSocketMessageRequest: Codable {
    public let senderUserId: String
    public let messageContent: String
    public let messageType: String
    
    public init(
        senderUserId: String,
        messageContent: String,
        messageType: String
    ) {
        self.senderUserId = senderUserId
        self.messageContent = messageContent
        self.messageType = messageType
    }
}
