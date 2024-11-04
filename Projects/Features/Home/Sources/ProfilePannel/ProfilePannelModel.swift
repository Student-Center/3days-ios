//
//  ProfilePannelModel.swift
//  Home
//
//  Created by 김지수 on 11/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class ProfilePannelModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var name: String? { get }
        var profile: UserInfoProfile? { get }
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var name: String? = nil
    @Published var profile: UserInfoProfile? = nil
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension ProfilePannelModel: ProfilePannelModel.Stateful {}

//MARK: - Actionable
protocol ProfilePannelModelActionable: AnyObject {
    // content
    func setName(name: String)
    func setProfile(profile: UserInfoProfile)
    func setValidation(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension ProfilePannelModel: ProfilePannelModelActionable {
    // content
    func setName(name: String) {
        self.name = name
    }
    func setProfile(profile: UserInfoProfile) {
        self.profile = profile
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
