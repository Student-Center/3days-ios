//
//  AuthPhoneInputModel.swift
//  SignUp
//
//  Created by 김지수 on 10/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

final class AuthPhoneInputModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var phoneInputText: String { get set }
        var isPhoneValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var phoneInputText: String = "010-"
    @Published var isPhoneValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension AuthPhoneInputModel: AuthPhoneInputModel.Stateful {}

//MARK: - Actionable
protocol AuthPhoneInputActionable: AnyObject {
    // content
    func setEditedPhoneText(phone: String)
    func setPhoneValidated(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
}

extension AuthPhoneInputModel: AuthPhoneInputActionable {
    // content
    func setEditedPhoneText(phone: String) {
        phoneInputText = phone
    }
    
    func setPhoneValidated(value: Bool) {
        isPhoneValidated = value
    }
    
    // default
    func setLoading(status: Bool) {}
    
    // error
    func showErrorView(error: ErrorModel) {}
    func showErrorAlert(error: ErrorModel) {}
}

