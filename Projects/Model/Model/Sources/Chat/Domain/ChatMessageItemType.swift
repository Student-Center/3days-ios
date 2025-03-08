//
//  ChatMessageItemType.swift
//  Model
//
//  Created by 김지수 on 2/24/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import CoreKit

//MARK: - ChatMessageItemType
public enum ChatMessageItemType {
    case dateSeperator(date: String)
    case messages(dateSource: [Message])
    case card(card: ChatCard)
    case systemMessage(content: ChatSystemMessage)
}

extension ChatMessageItemType: Identifiable {
    public var id: String {
        switch self {
        case .dateSeperator(let date):
            return date
        case .messages(let dataSource):
            return dataSource
                .map { $0.id }
                .joined()
        case .systemMessage(let content):
            return content.id
        case .card(let card):
            return card.id
        }
    }
}

//MARK: - Section Generator
extension Array where Element == Message {
    public var toMessageSectionItems: [ChatMessageItemType] {
        var result: [ChatMessageItemType] = []
        var currentGroup: [Message] = []
        var lastMessage: Message?
        
        for message in self {
            /*
             이전 메시지와 type 이 달라졌는지,
             시간 차이가 벌어졌는지 ?
             -> 섹션 분리
             */
            if let lastMessage = currentGroup.last,
               lastMessage.type == message.type &&
                hasSameMinute(
                    date1: lastMessage.createdAt,
                    date2: message.createdAt
                ) && message.content.contentType == .text
            {
                currentGroup.insert(message, at: 0)
            }
            else
            {
                // 텍스트 타입이 아닌 경우
                if message.content.contentType != .text {
                    if case let .systemMessage(systemMessage) = message.content.contentType {
                        result.append(
                            .systemMessage(
                                content: .init(
                                    id: message.id,
                                    message: systemMessage
                                )
                            )
                        )
                    }
                    
                    if case let .card(color) = message.content.contentType {
                        result.append(
                            .card(
                                card: .init(
                                    id: message.id,
                                    message: message.content.text,
                                    userType: message.type,
                                    color: color,
                                    createdAt: message.createdAt
                                )
                            )
                        )
                    }
                    
                    // date가 달라진 경우 구분 컴포넌트
                    if let dateSeperatorText = dateSeperatorIfNeeded(
                        previous: lastMessage?.createdAt,
                        new: message.createdAt
                    ) {
                        result.append(.dateSeperator(date: dateSeperatorText))
                    }
                    continue
                }
                
                // 이미 존재하던 그룹 append
                if currentGroup.isNotEmpty {
                    let messageGroup = updateBubbleTypes(for: currentGroup)
                    result.append(.messages(dateSource: messageGroup))
                    lastMessage = currentGroup.first
                    currentGroup = []
                }
                
                // date가 달라진 경우 구분 컴포넌트
                if let dateSeperatorText = dateSeperatorIfNeeded(
                    previous: lastMessage?.createdAt,
                    new: message.createdAt
                ) {
                    result.append(.dateSeperator(date: dateSeperatorText))
                }
                // 메시지 추가
                currentGroup.append(message)
            }
        }
        
        if currentGroup.isNotEmpty {
            result.append(.messages(dateSource: currentGroup))
            if let lastDate = currentGroup.last?.createdAt {
                let format = "M월 d일 (EEE)"
                let seperator = DateConverter.dateToString(
                    date: lastDate,
                    format: format
                )
                result.append(.dateSeperator(date: seperator))
            }
        }
        return result
    }
    
    // 분이 다른지 체크
    private func hasSameMinute(
        date1: Date?,
        date2: Date?
    ) -> Bool {
        guard let date1 = date1,
              let date2 = date2 else {
            return false
        }
        let convertedDate1 = DateConverter.dateToString(
            date: date1,
            format: "yyyyMMddHHmm"
        )
        let convertedDate2 = DateConverter.dateToString(
            date: date2,
            format: "yyyyMMddHHmm"
        )
        return convertedDate1 == convertedDate2
    }
    
    // 날짜가 다른지 체크
    private func dateSeperatorIfNeeded(
        previous: Date?,
        new: Date?
    ) -> String? {
        let format = "M월 d일 (EEE)"
        guard let new,
              let previous else { return nil }
        let previousDate = DateConverter.dateToString(
            date: previous,
            format: format
        )
        let newDate = DateConverter.dateToString(
            date: new,
            format: format
        )
        if previousDate != newDate {
            return previousDate
        }
        return nil
    }
    
    private func updateBubbleTypes(for messages: [Message]) -> [Message] {
        return messages.enumerated().map { index, message in
            var updatedMessage = message
            updatedMessage.bubbleType = getBubbleType(for: index, count: messages.count)
            updatedMessage.needShowAvatar = needShowAvatar(for: index, count: messages.count)
            switch updatedMessage.bubbleType {
            case .normal, .bottom:
                updatedMessage.showTimeStamp = true
            case .middle, .top:
                updatedMessage.showTimeStamp = false
            }
            return updatedMessage
        }
    }
    
    private func getBubbleType(for index: Int, count: Int) -> ChatBubbleType {
        switch count {
        case 1:
            return .normal
        case 2:
            return index == 0 ? .top : .bottom
        default:
            if index == 0 {
                return .top
            } else if index == count - 1 {
                return .bottom
            } else {
                return .middle
            }
        }
    }
    
    private func needShowAvatar(for index: Int, count: Int) -> Bool {
        switch count {
        case 1:
            return true
        default:
            return index == count - 1
        }
    }
}
