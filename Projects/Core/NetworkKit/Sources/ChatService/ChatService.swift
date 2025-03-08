//
//  ChatService.swift
//  CommonKit
//
//  Created by 김지수 on 2/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated
import Model

//MARK: - Service Protocol
public protocol ChatServiceProtocol {
    func requestChannelMessage(
        channeId: String,
        nextCursor: String?
    ) async throws -> MessageList
}

//MARK: - Service
public final class ChatService {
    public static let shared = ChatService()
    private init() {}
}

extension ChatService: ChatServiceProtocol {
    public func requestChannelMessage(
        channeId: String,
        nextCursor: String? = nil
    ) async throws -> MessageList {
        var response = try await client.getChannelMessages(
            .init(
                path: .init(
                    channelId: channeId
                ),
                query: .init(
                    next: nextCursor
                )
            )
        )
            .ok.body.json
        return MessageList(from: response)
    }
}
