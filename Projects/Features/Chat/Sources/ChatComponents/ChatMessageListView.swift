//
//  ChatMessageListView.swift
//  Chat
//
//  Created by 김지수 on 2/23/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import Model
import DesignCore

public struct ChatMessageListView: View {
    
    let messageDataSource: MessageList
    let hasNextPage: Bool
    @Binding var inputText: String
    @State private var textEditorHeight: CGFloat = 23
    @State private var textFieldSize: CGSize = .init()
    
    var sendAction: () -> Void
    var nextPageAction: () -> Void
    var cardTapHandler: (ChatCard) -> Void
    var nextCardTapHandler: (NextCard) -> Void
    var namespace: Namespace.ID
    
    @FocusState var isTextFieldFocused
    
    public var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(messageDataSource.toSectionItmes) { section in
                    LazyVStack(spacing: 2) {
                        switch section {
                        case .dateSeperator(let date):
                            dateSeperator(date)
                        case .messages(let dataSource):
                            messageSection(dataSource)
                        case .dateFlag(let dayNumber):
                            dayNumberFlag(dayNumber)
                        case .systemMessage(let content):
                            systemMessage(content)
                        case .card(let card):
                            cardView(card, tapHandler: cardTapHandler)
                        case .nextCard(let nextCard):
                            nextCardView(nextCard, tapHandler: nextCardTapHandler)
                        }
                    }
                    .id(section.id)
                    .flippedUpsideDown()
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                
                if hasNextPage {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .id(UUID().uuidString)
                    .flippedUpsideDown()
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .onAppear {
                        nextPageAction()
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .listStyle(PlainListStyle())
            .flippedUpsideDown()
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
        
        ChatInputContainerView(
            inputText: $inputText,
            isTextFieldFocused: _isTextFieldFocused,
            sendAction: sendAction
        )
    }
    
    //MARK: - Date Seperator: 날짜 구분 컴포넌트
    @ViewBuilder
    func dateSeperator(_ date: String) -> some View {
        let tintColor = Color(hex: 0x534C44)
        HStack(spacing: 10) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(tintColor.opacity(0.1))
            Text(date)
                .pretendard(weight: ._400, size: 12)
                .foregroundColor(tintColor.opacity(0.5))
                .padding(.vertical, 16)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(tintColor.opacity(0.1))
        }
        .padding(.horizontal, 10)
    }
    
    //MARK: - Message Section: 메시지 컴포넌트 (섹션별)
    @ViewBuilder
    func messageSection(_ dateSource: [Message]) -> some View {
        ForEach(dateSource) { message in
            ChatMessageItemView(
                text: message.content.text,
                userType: message.type,
                bubbleType: message.bubbleType,
                timeStamp: message.showTimeStamp ? message.sendTime : nil,
                avatarVisible: message.needShowAvatar
            )
        }
    }
    
    //MARK: - Card
    @ViewBuilder
    func cardView(
        _ content: ChatCard,
        tapHandler: @escaping (ChatCard) -> Void
    ) -> some View {
        if content.hasSent {
            switch content.userType {
            case .my:
                HStack(alignment: .bottom, spacing: 4) {
                    Spacer()
                    ChatTimeStampView(timeStamp: content.sendTime)
                    makeCard(
                        id: content.id,
                        color: content.color,
                        userType: content.userType,
                        hasRead: true,
                        tapHandler: {
                            tapHandler(content)
                        }
                    )
                }
            case .other:
                HStack(alignment: .bottom, spacing: 10) {
                    DesignCore.Images.profileDefault.image
                        .resizable()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .stroke(.white, lineWidth: 1)
                        }
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        makeCard(
                            id: content.id,
                            color: content.color,
                            userType: content.userType,
                            hasRead: true,
                            tapHandler: {
                                tapHandler(content)
                            }
                        )
                        
                        ChatTimeStampView(timeStamp: content.sendTime)
                    }
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    func makeCard(
        id: String,
        color: MessageContent.ColorType,
        userType: ChatUserType,
        hasRead: Bool,
        tapHandler: @escaping () -> Void
    ) -> some View {
        ZStack {
            color.cardImage
                .resizable()
            Circle()
                .fill(.black.opacity(0.4))
                .frame(width: 28, height: 28)
            switch userType {
            case .my:
                DesignCore.Images.iconArrowLeft.image
                    .resizable()
                    .frame(width: 16, height: 16)
            case .other:
                DesignCore.Images.iconArrowRight.image
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            if !hasRead {
                HStack {
                    Spacer()
                    VStack {
                        Circle()
                            .fill(Color(hex: 0xF2597F))
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 10, height: 10)
                        Spacer()
                    }
                }
                .padding(.all, 10)
            }
        }
        .frame(width: 85, height: 121)
        .contentShape(Rectangle())
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    tapHandler()
                }
        )
        .matchedTransitionSource(
            id: id,
            in: namespace
        )
        .shadow(.default)
    }
    
    @ViewBuilder
    func nextCardView(
        _ card: NextCard,
        tapHandler: @escaping (NextCard) -> Void
    ) -> some View {
        ZStack {
            card.cardColor.cardImage
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(card.nextCardTitle)
                .typography(.semibold_20)
                .foregroundStyle(card.cardColor.textColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
        }
        .frame(width: Device.width - 136)
        .contentShape(Rectangle())
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    tapHandler(card)
                }
        )
        .matchedTransitionSource(
            id: card.id,
            in: namespace
        )
        .shadow(.default)
        .padding(.vertical, 20)
    }
    
    //MARK: - Day Flag
    @ViewBuilder
    func dayNumberFlag(_ dayNumber: Int) -> some View {
        VStack {
            switch dayNumber {
            case 1:
                DesignCore.Images.iconDay1.image
                    .resizable()
            case 2:
                DesignCore.Images.iconDay2.image
                    .resizable()
            case 3:
                DesignCore.Images.iconDay3.image
                    .resizable()
            default:
                EmptyView()
            }
        }
        .frame(width: 80, height: 48)
        .padding(.top, 24)
    }
    
    //MARK: - System Message
    @ViewBuilder
    func systemMessage(_ content: ChatSystemMessage) -> some View {
        VStack(spacing: 16) {
            DesignCore.Images.weavyProfile.image
                .resizable()
                .frame(width: 50, height: 50)
            
            Text(content.message)
                .typography(.regular_15)
                .multilineTextAlignment(.center)
            
            Divider()
                .foregroundStyle(Color(hex: 0x534C44).opacity(0.1))
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        ZStack {
            ChatContainerView()
        }
    }
}

extension MessageContent.ColorType {
    var cardImage: Image {
        switch self {
        case .blue:
            return DesignCore.Images.cardBlue.image
        case .pink:
            return DesignCore.Images.cardPink.image
        }
    }
    
    var cardColor: Color {
        switch self {
        case .blue:
            return Color(hex: 0xDAE6F1)
        case .pink:
            return Color(hex: 0xF3DDE5)
        }
    }
    
    var textColor: Color {
        switch self {
        case .blue:
            DesignCore.Colors.blue500
        case .pink:
            DesignCore.Colors.pink500
        }
    }
}
