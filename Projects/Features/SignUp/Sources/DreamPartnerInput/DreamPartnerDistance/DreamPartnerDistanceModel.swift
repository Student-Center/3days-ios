//
//  DreamPartnerDistanceModel.swift
//  DesignPreview
//
//  Created by 김지수 on 10/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import SignUpDomain

final class DreamPartnerDistanceModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var selectedDistanceType: DreamPartnerDistanceType? { get }
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var selectedDistanceType: DreamPartnerDistanceType?
    var isValidated: Bool {
        selectedDistanceType != nil
    }
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension DreamPartnerDistanceModel: DreamPartnerDistanceModel.Stateful {}

//MARK: - Actionable
protocol DreamPartnerDistanceModelActionable: AnyObject {
    // content
    func setDistanceType(_ type: DreamPartnerDistanceType)
    func setValidation(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension DreamPartnerDistanceModel: DreamPartnerDistanceModelActionable {
    // content
    func setDistanceType(_ type: DreamPartnerDistanceType) {
        selectedDistanceType = type
    }
    func setValidation(value: Bool) {}
    
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
