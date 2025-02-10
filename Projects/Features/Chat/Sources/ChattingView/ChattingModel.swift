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

final class ChattingModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var isValidated: Bool = false
    
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
