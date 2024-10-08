//
//  AuthProfileAgeInputModel.swift
//  SignUp
//
//  Created by 김지수 on 10/6/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

final class AuthProfileAgeInputModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var birthYear: String { get set }
        var errorMessage: String? { get set }
        var isFocused: Bool { get }
        var isValidated: Bool { get }
        var targetGender: GenderType { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var isValidated: Bool = false
    @Published var errorMessage: String? = "오류가 발생했어요"
    @Published var birthYear = String()
    @Published var isFocused: Bool = false
    @Published var targetGender: GenderType = .female
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension AuthProfileAgeInputModel: AuthProfileAgeInputModel.Stateful {}

//MARK: - Actionable
protocol AuthProfileAgeInputModelActionable: AnyObject {
    // content
    func setBirthYear(year: String)
    func setFocuse(_ value: Bool)
    func setValidation(value: Bool)
    func setTargetGender(_ gender: GenderType)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension AuthProfileAgeInputModel: AuthProfileAgeInputModelActionable {
    // content
    func setBirthYear(year: String) {
        birthYear = year
    }
    func setFocuse(_ value: Bool) {
        isFocused = value
    }
    func setValidation(value: Bool) {
        isValidated = value
    }
    func setTargetGender(_ gender: GenderType) {
        targetGender = gender
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
