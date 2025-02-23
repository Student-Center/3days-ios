//
//  ChatMessageItemView.swift
//  Chat
//
//  Created by 김지수 on 2/23/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import Model
import DesignCore

public struct ChatMessageItemView: View {
    
    let text: String
    let userType: ChatUserType
    let bubbleType: ChatBubbleType
    let timeStamp: String?
    let avatarVisible: Bool
    
    public var body: some View {
        switch userType {
            
        case .other(_):
            HStack(alignment: .bottom, spacing: 10) {
                if avatarVisible {
                    DesignCore.Images.profileDefault.image
                        .resizable()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .stroke(.white, lineWidth: 1)
                        }
                } else {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 24, height: 24)
                }
                
                ChatBubble(
                    text: text,
                    timeStamp: timeStamp,
                    userType: userType,
                    bubbleType: bubbleType
                )
                
                Spacer()
            }
            
        case .my:
            HStack {
                Spacer()
                
                ChatBubble(
                    text: text,
                    timeStamp: timeStamp,
                    userType: userType,
                    bubbleType: bubbleType
                )
            }
        }
    }
}

extension ChatUserType {
    var textColor: Color {
        switch self {
        case .my: return .white
        case .other: return DesignCore.Colors.grey500
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .my: return Color(hex: 0x5E9BF7)
        case .other: return .white
        }
    }
    
    var alignment: Alignment {
        switch self {
        case .my: return .trailing
        case .other: return .leading
        }
    }
}
