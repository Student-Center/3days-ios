//
//  ChatDomain.swift
//  Model
//
//  Created by 김지수 on 2/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import UIKit
import SwiftUI
import CoreKit
import OpenapiGenerated

public struct MessageList {
    public var messages: [Message]
    public var hasNext: Bool?
    public var nextCursor: String?
    
    public var toSectionItmes: [ChatMessageItemType] {
        return messages.toMessageSectionItems
    }
    
    public init(
        messages: [Message],
        hasNext: Bool?,
        nextCursor: String?
    ) {
        self.messages = messages
        self.hasNext = hasNext
        self.nextCursor = nextCursor
    }
    
    public init(from dto: Components.Schemas.GetChannelMessagesResponse) {
        if let messages = dto.messages {
            self.messages = messages.map { Message(from: $0) }
        } else {
            self.messages = []
        }
        self.hasNext = dto.next != nil
        self.nextCursor = dto.next
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
    public let senderUserId: String?
    public let content: MessageContent
    public let type: ChatUserType
    public let createdAt: Date?
    public var bubbleType: ChatBubbleType = .normal
    public var needShowAvatar: Bool = true
    public var showTimeStamp: Bool = true
    public var isLoading: Bool = false
    
    public var sendTime: String {
        return DateConverter.dateToString(
            date: createdAt,
            format: "a h시 m분"
        )
    }
    
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
    
    public init(content: MessageContent.ContentType) {
        self.id = UUID().uuidString
        self.content = .init(type: content, text: "")
        self.type = .other(.init(id: ""))
        self.senderUserId = ""
        self.createdAt = Date()
    }
    
    public init(from dto: Components.Schemas.Message) {
        self.id = dto.id
        self.senderUserId = dto.senderUserId
        self.createdAt = DateConverter.stringToDate(
            string: dto.createdAt,
            format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        )
        self.type = senderUserId == TokenManager.userId ? .my : .other(.init(id: senderUserId ?? ""))
        self.content = MessageContent(from: dto.content)
    }
    
    public init(from dto: ChatSocketResponse) {
        self.id = dto.id
        self.senderUserId = dto.senderUserId
        self.createdAt = DateConverter.stringToDate(string: dto.createdAt)
        self.type = senderUserId == TokenManager.userId ? .my : .other(.init(id: senderUserId ?? ""))
        self.content = MessageContent(from: dto.content)
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
    
    public enum ContentType: Equatable {
        case text
        case card(ColorType)
        case dateFlag(Int)
        case systemMessage(String)
        case nextCard(String, ColorType)
        
        public static func == (lhs: MessageContent.ContentType, rhs: MessageContent.ContentType) -> Bool {
            switch (lhs, rhs) {
            case (.text, .text):
                return true
            case (.card(let lhsColor), .card(let rhsColor)):
                return lhsColor == rhsColor
            case (.dateFlag(let lhs), .dateFlag(let rhs)):
                return lhs == rhs
            case (.systemMessage(let lhs), .systemMessage(let rhs)):
                return lhs == rhs
            default:
                return false
            }
        }
    }
    
    public let contentType: ContentType
    public let text: String
    public let title: String?
    
    init(type: ContentType, text: String) {
        self.contentType = type
        self.text = text
        self.title = nil
    }
    
    init(from dto: Components.Schemas.MessageContent) {
        self.text = dto.text
        self.title = dto.title
        
        switch dto._type {
        case .TEXT:
            self.contentType = .text
        case .CARD:
            self.contentType = .card(
                dto.cardColor == .BLUE ? .blue : .pink
            )
        case .SYSTEM:
            if let nextCardTitle = dto.nextCardTitle,
               dto.systemMessageType == .NEXT_CARD {
                let cardColor: ColorType = dto.cardColor == .BLUE ? .blue : .pink
                self.contentType = .nextCard(nextCardTitle, cardColor)
            } else {
                self.contentType = .systemMessage(dto.text)
            }
        }
    }
    
    init(from dto: ChatSocketResponse.Content) {
        self.text = dto.text
        self.title = dto.title
        switch dto.type {
        case "TEXT":
            self.contentType = .text
        case "CARD":
            let cardColor: ColorType = dto.cardColor == "BLUE" ? .blue : .pink
            self.contentType = .card(cardColor)
        case "SYSTEM":
            self.contentType = .systemMessage(dto.text)
        default:
            self.contentType = .text
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
            .init(message: "(mock)안녕", type: .my),
            .init(message: "(mock)3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "(mock)헤헤", type: .my),
            .init(message: "(mock)안녕", type: .other(.init(id: "2"))),
            .init(message: "(mock)안녕", type: .my),
            .init(message: "(mock)님", type: .other(.init(id: "2"))),
            .init(content: .systemMessage("안녕하세요")),
            .init(message: "(mock)3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다. 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "(mock)하세요", type: .other(.init(id: "2"))),
            .init(message: "(mock)안녕", type: .my),
            .init(message: "(mock)3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "(mock)헤헤", type: .my),
            .init(message: "(mock)안녕", type: .other(.init(id: "2"))),
            .init(message: "(mock)안녕", type: .my),
            .init(message: "(mock)님", type: .other(.init(id: "2"))),
            .init(message: "(mock)3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다. 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "(mock)하세요", type: .other(.init(id: "2"))),
            .init(message: "(mock)안녕", type: .my),
            .init(message: "(mock)3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "(mock)헤헤", type: .my),
            .init(message: "(mock)안녕", type: .other(.init(id: "2"))),
            .init(message: "(mock)안녕", type: .my),
            .init(message: "(mock)님", type: .other(.init(id: "2"))),
            .init(message: "(mock)3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다. 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "(mock)하세요", type: .other(.init(id: "2"))),
            .init(message: "(mock)안녕", type: .my),
            .init(message: "(mock)3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "(mock)헤헤", type: .my),
            .init(message: "(mock)안녕", type: .other(.init(id: "2"))),
            .init(message: "(mock)안녕", type: .my),
            .init(message: "(mock)님", type: .other(.init(id: "2"))),
            .init(message: "(mock)3days는 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다. 3일 동안 딱 한 사람만 알아가는 신개념 소개팅 앱입니다.", type: .other(.init(id: "2"))),
            .init(message: "(mock)하세요", type: .other(.init(id: "2")))
            ]
    }
}
