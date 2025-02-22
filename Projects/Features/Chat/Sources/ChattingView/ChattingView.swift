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
    
    @State private var inputText: String = ""
    
    private var intent: ChattingIntent.Intentable { container.intent }
    private var state: ChattingModel.Stateful { container.model }
    
    public init(token: String? = TokenManager.accessToken) {
        let model = ChattingModel()
        let intent = ChattingIntent(
            model: model,
            input: .init(),
            customToken: token
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
            ZStack {
                ChattingListView(
                    messageDataSource: state.messageDataSource,
                    inputText: $inputText,
                    sendAction: {
                        intent.sendMessage(inputText)
                        inputText = ""
                    }
                )
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

public struct ChattingListView: View {
    
    let messageDataSource: MessageList
    @Binding var inputText: String
    @State private var textEditorHeight: CGFloat = 23
    @State private var textFieldSize: CGSize = .init()
    
    var sendAction: () -> Void
    
    @FocusState var isTextFieldFocused
    
    public var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(messageDataSource.messageWithSections, id: \.self) { section in
                        LazyVStack(spacing: 2) {
                            ForEach(section) { model in
                                ChatBubbleHorizontalLineView(
                                    text: model.content.text,
                                    userType: model.type,
                                    bubbleType: model.bubbleType,
                                    timeStamp: model.showTimeStamp ? model.sendTime : nil,
                                    avatarVisible: model.needShowAvatar
                                )
                            }
                        }
                    }
                }
                .rotationEffect(Angle(degrees: 180))
                .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                .padding(.horizontal, 18)
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture {
                isTextFieldFocused = false
            }
            
            TextInputContainerView(
                inputText: $inputText,
                isTextFieldFocused: _isTextFieldFocused,
                sendAction: sendAction
            )
        }
    }
}

struct TextInputContainerView: View {
    
    @Binding var inputText: String
    @State var textFieldSize: CGSize = .init()
    @FocusState var isTextFieldFocused
    
    var sendAction: () -> Void
    
    private var textFieldHeight: CGFloat {
        return textFieldSize.height
    }
    
    private let textInputViewMinHeight: CGFloat = 60
    private let textInputViewMaxHeight: CGFloat = 108
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            HStack(alignment: .bottom, spacing: 0) {
                TextInputFieldView(
                    text: $inputText,
                    textFieldSize: $textFieldSize,
                    isTextFieldFocused: _isTextFieldFocused
                )
                
                Button {
                    sendAction()
                } label: {
                    if inputText.isEmpty {
                        DesignCore.Images.iconSend.image
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                    } else {
                        DesignCore.Images.iconSendFilled.image
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                    }
                }
                .disabled(inputText.isEmpty)
            }
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(hex: 0xF7F3F1))
            }
            .frame(
                maxHeight: textFieldSize.height < textInputViewMaxHeight ? nil : textInputViewMaxHeight,
                alignment: .bottom
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.clear)
    }
}

struct TextInputFieldView: View {
    
    @Binding var text: String
    @Binding var textFieldSize: CGSize
    @FocusState var isTextFieldFocused

    var body: some View {
        TextField(
            "메시지 보내기",
            text: $text,
            axis: .vertical
        )
        .focused($isTextFieldFocused)
        .pretendard(
            weight: ._400,
            size: 16,
            lineHeight: 24
        )
        .foregroundStyle(Color(hex: 0x17171B))
        .padding(.vertical, 10)
        .padding(.leading, 20)
        .tint(DesignCore.Colors.grey500)
        .frame(minHeight: 60)
        .sizeGetter($textFieldSize)
    }
}

public struct ChatBubbleHorizontalLineView: View {
    
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
            Text(timeStamp)
                .pretendard(weight: ._400, size: 10)
                .foregroundStyle(Color(hex: 0x534C44).opacity(0.5))
        }
    }
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
