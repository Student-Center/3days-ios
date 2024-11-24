//
//  DateProfilePanelModel.swift
//  Home
//
//  Created by 김지수 on 11/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class DateProfilePanelModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var dreamPartnerInfo: DreamPartnerInfo? { get }
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var dreamPartnerInfo: DreamPartnerInfo?
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension DateProfilePanelModel: DateProfilePanelModel.Stateful {}

//MARK: - Actionable
protocol DateProfilePanelModelActionable: AnyObject {
    // content
    func setDreamPartnerInfo(_ info: DreamPartnerInfo)
    func setValidation(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension DateProfilePanelModel: DateProfilePanelModelActionable {
    // content
    func setDreamPartnerInfo(_ info: DreamPartnerInfo) {
        dreamPartnerInfo = info
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
