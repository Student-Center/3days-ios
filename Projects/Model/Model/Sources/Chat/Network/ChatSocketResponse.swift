//
//  ChatSocketResponse.swift
//  Model
//
//  Created by 김지수 on 2/20/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation

public struct ChatSocketResponse: Codable {
    let id: String
    let channelId: String
    let senderUserId: String
    let content: Content
    let createdAt: String
    
    public struct Content: Codable {
        let type: String
        let text: String
        let cardColor: String?
    }
}
