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
                    
                    ForEach(messageDataSource.messageWithSections, id: \.self) { section in
                        LazyVStack(spacing: 2) {
                            ForEach(section) { model in
                                ChatMessageItemView(
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
}
