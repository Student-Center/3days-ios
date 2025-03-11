//
//  ChatBubbleView.swift
//  Chat
//
//  Created by 김지수 on 2/23/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore
import Model

public struct ChatBubble: View {
    
    let text: String
    let timeStamp: String?
    let userType: ChatUserType
    let bubbleType: ChatBubbleType
    
    var chatBubbleMaxWidth: CGFloat {
        return Device.width * 0.648 + (timeStamp != nil ? 42 : 0)
    }
    
    public var body: some View {
        ZStack(alignment: userType.alignment) {
            HStack(alignment: .bottom, spacing: 4) {
                if userType == .my {
                    timeStampView
                }
                
                Text(text)
                    .typography(.regular_15)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(userType.textColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(content: {
                        let largeRadiusValue: CGFloat = 20
                        let smallRadiusValue: CGFloat = 4
                        
                        switch bubbleType {
                        case .normal:
                            RoundedRectangle(cornerRadius: largeRadiusValue)
                                .fill(userType.backgroundColor)
                        case .top:
                            let corners: UIRectCorner = userType == .my ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight]
                            let subtractedCorner = UIRectCorner.allCorners.subtracting(corners)
                            Rectangle()
                                .fill(userType.backgroundColor)
                                .cornerRadius(largeRadiusValue, corners: corners)
                                .cornerRadius(smallRadiusValue, corners: subtractedCorner)
                            
                        case .middle:
                            let corners: UIRectCorner = userType == .my ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight]
                            let subtractedCorner = UIRectCorner.allCorners.subtracting(corners)
                            Rectangle()
                                .fill(userType.backgroundColor)
                                .cornerRadius(largeRadiusValue, corners: corners)
                                .cornerRadius(smallRadiusValue, corners: subtractedCorner)
                        case .bottom:
                            let corners: UIRectCorner = userType == .my ? [.bottomLeft, .topLeft, .bottomRight] : [.topRight, .bottomLeft, .bottomRight]
                            let subtractedCorner = UIRectCorner.allCorners.subtracting(corners)
                            Rectangle()
                                .fill(userType.backgroundColor)
                                .cornerRadius(largeRadiusValue, corners: corners)
                                .cornerRadius(smallRadiusValue, corners: subtractedCorner)
                        }
                    })
                    .multilineTextAlignment(.leading)
                
                if case .other(_) = userType {
                    timeStampView
                }
            }
            .frame(
                maxWidth: chatBubbleMaxWidth,
                alignment: userType == .my ? .trailing : .leading
            )
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    @ViewBuilder
    var timeStampView: some View {
        if let timeStamp {
            ChatTimeStampView(timeStamp: timeStamp)
        }
    }
}
