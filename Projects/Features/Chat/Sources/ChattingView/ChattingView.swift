//
//  ChattingView.swift
//  Chat
//
//  Created by 김지수 on 2/4/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct ChattingView: View {
    
    @StateObject var container: MVIContainer<ChattingIntent.Intentable, ChattingModel.Stateful>
    
    private var intent: ChattingIntent.Intentable { container.intent }
    private var state: ChattingModel.Stateful { container.model }
    
    public init() {
        let model = ChattingModel()
        let intent = ChattingIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as ChattingIntent.Intentable,
            model: model as ChattingModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        VStack {
            ChattingListView()
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.all)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

public struct ChattingListView: View {
    public var body: some View {
        VStack {
            ForEach(ChatDomain.mock) { model in
                ChatBubbleHorizontalLineView(
                    text: model.message,
                    userType: model.type,
                    bubbleType: .top
                )
            }
        }
        .padding(.horizontal, 18)
    }
}

public struct ChatBubbleHorizontalLineView: View {
    
    let text: String
    let userType: ChatUserType
    let bubbleType: ChatBubbleType
    var chatBubbleMaxWidth: CGFloat {
        return Device.width * 0.648
    }
    
    public var body: some View {
        switch userType {
            
        case .other(let otherUser):
            HStack(alignment: .bottom, spacing: 10) {
                DesignCore.Images.profileDefault.image
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    .background {
                        Circle()
                            .stroke(.white, lineWidth: 1)
                    }
                
                ChatBubble(
                    text: text,
                    userType: userType,
                    bubbleType: bubbleType
                )
                .multilineTextAlignment(.leading)
                .frame(maxWidth: chatBubbleMaxWidth, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            
        case .my:
            HStack {
                Spacer()
                
                ChatBubble(
                    text: text,
                    userType: userType,
                    bubbleType: bubbleType
                )
                .multilineTextAlignment(.leading)
                .frame(maxWidth: chatBubbleMaxWidth, alignment: .trailing)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

public struct ChatBubble: View {
    
    let text: String
    let userType: ChatUserType
    let bubbleType: ChatBubbleType
    
    public var body: some View {
        ZStack(alignment: userType.alignment) {
            Text(text)
                .typography(.regular_15)
                .multilineTextAlignment(.leading)
                .foregroundStyle(userType.textColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(content: {
                    let radiusValue: CGFloat = 20
                    switch bubbleType {
                    case .normal:
                        RoundedRectangle(cornerRadius: radiusValue)
                            .fill(userType.backgroundColor)
                    case .top:
                        let corners: UIRectCorner = userType == .my ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight]
                        Rectangle()
                            .fill(userType.backgroundColor)
                            .cornerRadius(radiusValue, corners: corners)
                    case .middle:
                        let corners: UIRectCorner = userType == .my ? [.topLeft, .bottomLeft] : [.topLeft, .topRight, .bottomRight]
                        Rectangle()
                            .fill(userType.backgroundColor)
                            .cornerRadius(radiusValue, corners: corners)
                    case .bottom:
                        let corners: UIRectCorner = userType == .my ? [.bottomLeft, .topRight, .bottomRight] : [.bottomLeft, .topLeft, .bottomRight]
                        Rectangle()
                            .fill(userType.backgroundColor)
                            .cornerRadius(radiusValue, corners: corners)
                    }
                })
        }
    }
}

enum ChatBubbleType {
    case top
    case middle
    case bottom
    case normal
}

#Preview {
    NavigationView {
        ZStack {
            ChattingView()
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
