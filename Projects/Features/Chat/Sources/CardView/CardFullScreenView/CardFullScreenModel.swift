//
//  CardFullScreenModel.swift
//  Chat
//
//  Created by 김지수 on 3/18/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class CardFullScreenModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var isValidated: Bool { get }
        
        // default
        var card: ChatCard? { get }
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var card: ChatCard?
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension CardFullScreenModel: CardFullScreenModel.Stateful {}

//MARK: - Actionable
protocol CardFullScreenModelActionable: AnyObject {
    // content
    func setValidation(value: Bool)
    func setCardData(card: ChatCard)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension CardFullScreenModel: CardFullScreenModelActionable {
    // content
    func setValidation(value: Bool) {
        isValidated = value
    }
    
    func setCardData(card: ChatCard) {
        self.card = card
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
