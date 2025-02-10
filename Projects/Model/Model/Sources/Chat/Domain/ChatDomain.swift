//
//  ChatDomain.swift
//  Model
//
//  Created by 김지수 on 2/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation

public struct ChatDomain: Identifiable {
    public let id: String
    public let message: String
    public let type: ChatUserType
    
    public init(message: String, type: ChatUserType) {
        self.id = UUID().uuidString
        self.message = message
        self.type = type
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

extension ChatDomain {
    public static var mock: [ChatDomain] {
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
