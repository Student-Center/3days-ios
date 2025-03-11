//
//  ChatCard.swift
//  Model
//
//  Created by 김지수 on 3/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import CoreKit

public struct ChatCard {
    public let id: String
    public let message: String
    public let userType: ChatUserType
    public let color: MessageContent.ColorType
    public let createdAt: Date?
    public let hasSent: Bool = true
    
    public var sendTime: String {
        return DateConverter.dateToString(
            date: createdAt,
            format: "a h시 m분"
        )
    }
}
