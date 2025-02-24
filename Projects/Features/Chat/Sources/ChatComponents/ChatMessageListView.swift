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
    
    @FocusState var isTextFieldFocused
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 10) {
                    
                    // pagination
                    if hasNextPage {
                        ProgressView()
                            .onAppear {
                                nextPageAction()
                            }
                    }
                    
                    ForEach(messageDataSource.toSectionItmes) { section in
                        LazyVStack(spacing: 2) {
                            switch section {
                            case .dateSeperator(let date):
                                dateSeperator(date)
                            case .messages(let dataSource):
                                messageSection(dataSource)
                            }
                        }
                    }
                }
                .rotationEffect(Angle(degrees: 180))
                .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture {
                isTextFieldFocused = false
            }
            
            ChatInputContainerView(
                inputText: $inputText,
                isTextFieldFocused: _isTextFieldFocused,
                sendAction: sendAction
            )
        }
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
}

#Preview {
    NavigationView {
        ZStack {
            ChatContainerView()
        }
    }
}
