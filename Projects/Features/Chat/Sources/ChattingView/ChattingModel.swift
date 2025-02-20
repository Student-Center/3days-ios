//
//  ChattingModel.swift
//  Chat
//
//  Created by 김지수 on 2/4/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class ChattingModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var messageDataSource: MessageList { get }
        var isSocketConnected: Bool { get }
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var messageDataSource: MessageList = .init(
        messages: [],
        hasNext: nil,
        nextCursor: nil
    )
    @Published var isValidated: Bool = false
    @Published var isSocketConnected: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension ChattingModel: ChattingModel.Stateful {}

//MARK: - Actionable
protocol ChattingModelActionable: AnyObject {
    // content
    func setValidation(value: Bool)
    func setSocketStatus(isConnected: Bool)
    
    func socketReceivedNewMessage(message: Message)
    
    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension ChattingModel: ChattingModelActionable {
    // content
    func setValidation(value: Bool) {
        isValidated = value
    }
    func setSocketStatus(isConnected: Bool) {
        isSocketConnected = isConnected
    }
    func socketReceivedNewMessage(message: Message) {
        print("💬 [Received]", message)
        messageDataSource.messages.append(message)
        
    }
    
    // default
    func setLoading(status: Bool) {
        isLoading = status
    }
    
    // error
    func showErrorView(error: ErrorModel) {
        showErrorView = error
    }
    func showErrorAlert(error: ErrorModel) {
        showErrorAlert = error
    }
    func resetError() {
        showErrorView = nil
        showErrorAlert = nil
    }
}
