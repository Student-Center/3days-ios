//
//  AuthGreetingModel.swift
//  SignUp
//
//  Created by 김지수 on 10/5/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

final class AuthGreetingModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var isAppeared: Bool { get }
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
    @Published var isAppeared: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension AuthGreetingModel: AuthGreetingModel.Stateful {}

//MARK: - Actionable
protocol AuthGreetingModelActionable: AnyObject {
    // content
    func setIsAppeared(value: Bool)
    func setValidation(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension AuthGreetingModel: AuthGreetingModelActionable {
    // content
    func setIsAppeared(value: Bool) {
        isAppeared = value
    }
    
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
