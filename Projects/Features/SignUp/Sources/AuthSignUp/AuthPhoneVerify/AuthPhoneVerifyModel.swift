//
//  AuthPhoneVerifyModel.swift
//  DesignPreview
//
//  Created by 김지수 on 10/4/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CommonKit
import CoreKit

final class AuthPhoneVerifyModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var verifyCode: String { get set }
        var errorMessage: String? { get set }
        var verifyTextFieldFocused: Bool { get set }
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
    @Published var verifyCode = ""
    @Published var errorMessage: String? = "에러에여"
    @Published var verifyTextFieldFocused: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension AuthPhoneVerifyModel: AuthPhoneVerifyModel.Stateful {}

//MARK: - Actionable
protocol AuthPhoneVerifyModelActionable: AnyObject {
    // content
    func setValidation(value: Bool)
    func setTextFieldFocus(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension AuthPhoneVerifyModel: AuthPhoneVerifyModelActionable {
    // content
    func setValidation(value: Bool) {
        isValidated = value
    }
    func setTextFieldFocus(value: Bool) {
        verifyTextFieldFocused = value
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
