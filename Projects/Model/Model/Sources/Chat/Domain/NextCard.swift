//
//  NextCard.swift
//  Model
//
//  Created by Jisu Kim on 3/26/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation

public struct NextCard: Identifiable {
    public let id: String
    public let nextCardTitle: String
    public let cardColor: MessageContent.ColorType
}
