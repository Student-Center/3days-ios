//
//  AuthNameInputModel.swift
//  SignUp
//
//  Created by 김지수 on 10/7/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

final class AuthNameInputModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var inputText: String { get set }
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var inputText: String = ""
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension AuthNameInputModel: AuthNameInputModel.Stateful {}

//MARK: - Actionable
protocol AuthNameInputModelActionable: AnyObject {
    // content
    func setInputText(_ text: String)
    func setValidation(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension AuthNameInputModel: AuthNameInputModelActionable {
    // content
    func setInputText(_ text: String) {
        inputText = text
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
