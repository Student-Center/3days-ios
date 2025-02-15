//
//  ChatDomain.swift
//  Model
//
//  Created by 김지수 on 2/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import UIKit
import CoreKit
import OpenapiGenerated

public struct MessageList {
    public let messages: [Message]?
    public let hasNext: Bool?
    public let nextCursor: String?
    
    public init(
        messages: [Message],
        hasNext: Bool?,
        nextCursor: String?
    ) {
        self.messages = messages
        self.hasNext = hasNext
        self.nextCursor = nextCursor
    }
    
    public init(from dto: Components.Schemas.MessageList) {
        self.messages = dto.messages?.map { Message(from: $0) }
        self.hasNext = dto.hasNext
        self.nextCursor = dto.nextCursor
    }
}

public struct Message: Identifiable, Hashable, Equatable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public let id: String
    public let senderUserId: String
    public let content: MessageContent
    public let type: ChatUserType
    public let createdAt: Date?
    public var bubbleType: ChatBubbleType = .normal
    public var needShowAvatar: Bool = true
    
    public init(
        id: String,
        senderUserId: String,
        content: MessageContent,
        type: ChatUserType,
        createdAt: Date?,
        bubbleType: ChatBubbleType
    ) {
        self.id = id
        self.senderUserId = senderUserId
        self.content = content
        self.type = type
        self.createdAt = createdAt
        self.bubbleType = bubbleType
    }
    
    public init(message: String, type: ChatUserType) {
        self.id = UUID().uuidString
        self.content = .init(type: .text, text: message)
        self.type = type
        self.senderUserId = ""
        self.createdAt = Date()
    }
    
    public init(from dto: Components.Schemas.Message) {
        self.id = dto.id
        self.senderUserId = dto.senderUserId
        self.createdAt = dto.createdAt
        self.type = senderUserId == TokenManager.userId ? .my : .other(.init(id: senderUserId))
        self.content = MessageContent(from: dto.content)
    }
}

extension Array where Element == Message {
    public var toMessageSections: [[Message]] {
        var result: [[Message]] = []
        var currentGroup: [Message] = []
        
        for message in self {
            if let lastMessage = currentGroup.last,
               lastMessage.type == message.type {
                currentGroup.append(message)
            } else {
                if !currentGroup.isEmpty {
                    result.append(updateBubbleTypes(for: currentGroup))
                }
                currentGroup = [message]
            }
        }

        if !currentGroup.isEmpty {
            result.append(updateBubbleTypes(for: currentGroup))
        }

        return result
    }
    
    private func updateBubbleTypes(for messages: [Message]) -> [Message] {
        return messages.enumerated().map { index, message in
            var updatedMessage = message
            updatedMessage.bubbleType = getBubbleType(for: index, count: messages.count)
            updatedMessage.needShowAvatar = needShowAvatar(for: index, count: messages.count)
            return updatedMessage
        }
    }
    
    private func getBubbleType(for index: Int, count: Int) -> ChatBubbleType {
        switch count {
        case 1:
            return .normal
        case 2:
            return index == 0 ? .top : .bottom
        default:
            if index == 0 {
                return .top
            } else if index == count - 1 {
                return .bottom
            } else {
                return .middle
            }
        }
    }
    
    private func needShowAvatar(for index: Int, count: Int) -> Bool {
        switch count {
        case 1:
            return true
        default:
            return index == count - 1
        }
    }
}

public enum ChatBubbleType {
    case top
    case middle
    case bottom
    case normal
}


public struct MessageContent {
    public enum ColorType {
        case blue
        case pink
    }
    
    public enum `Type` {
        case text
        case card(ColorType)
    }
    
    public let type: Type
    public let text: String
    
    init(type: Type, text: String) {
        self.type = type
        self.text = text
    }
    
    init(from dto: Components.Schemas.MessageContent) {
        self.text = dto.text ?? ""
        switch dto._type {
        case .TEXT:
            self.type = .text
        case .CARD:
            self.type = .card(dto.cardColor == .BLUE ? .blue : .pink)
        case .none:
            self.type = .text
        }
    }
}

public enum ChatUserType: Equatable {
    case my
    case other(OtherUser)
}

public struct OtherUser: Equatable {
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension Message {
    public static var mock: [Message] {
        return [
            .init(message: "안녕", type: .my),
            .init(message: "3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "헤헤", type: .my),
            .init(message: "안녕", type: .other(.init(id: "2"))),
            .init(message: "안녕", type: .my),
            .init(message: "님", type: .other(.init(id: "2"))),
            .init(message: "3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다. 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "하세요", type: .other(.init(id: "2")))
            
            ]
    }
}
