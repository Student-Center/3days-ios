//
//  HomeMainModel.swift
//  DesignPreview
//
//  Created by 김지수 on 11/2/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class HomeMainModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var userInfo: UserInfo? { get }
        var selectedTab: HomeMainTab { get set }
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
    @Published var selectedTab: HomeMainTab = .profile
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension HomeMainModel: HomeMainModel.Stateful {}

//MARK: - Actionable
protocol HomeMainModelActionable: AnyObject {
    // content
    func setUserInfo(userInfo: UserInfo)
    func setSelectedTab(tab: HomeMainTab)
    func setValidation(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension HomeMainModel: HomeMainModelActionable {
    // content
    func setUserInfo(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    func setSelectedTab(tab: HomeMainTab) {
        self.selectedTab = tab
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
