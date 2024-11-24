//
//  EditProfileCompanyModel.swift
//  SignUp
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import SearchCompany
import Model

final class EditProfileCompanyModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var userInfo: UserInfo? { get }
        var searchCompanyState: SearchCompanyModel.Stateful { get }
        
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var userInfo: UserInfo?
    @Published var searchCompanyState: SearchCompanyModel.Stateful
    
    var isValidated: Bool {
        return searchCompanyState.isValidated
    }
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
    
    init(searchCompanyState: SearchCompanyModel.Stateful) {
        self.searchCompanyState = searchCompanyState
    }
}

extension EditProfileCompanyModel: EditProfileCompanyModel.Stateful {}

//MARK: - Actionable
protocol EditProfileCompanyModelActionable: AnyObject {
    // content
    func setUserInfo(userInfo: UserInfo)
    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension EditProfileCompanyModel: EditProfileCompanyModelActionable {
    // content
    func setUserInfo(userInfo: UserInfo) {
        self.userInfo = userInfo
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
