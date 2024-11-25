//
//  EditDateProfileAgeRangeModel.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class EditDateProfileAgeRangeModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var upperValue: String? { get }
        var lowerValue: String? { get }
        var isValidated: Bool { get }
        var userInfo: UserInfo? { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    var userInfo: UserInfo?
    @Published var upperValue: String?
    @Published var lowerValue: String?
    
    var isValidated: Bool {
        if let dreamPartnerInfo = userInfo?.dreamPartner,
           let lowerBirthYear = dreamPartnerInfo.lowerBirthYear,
           let upperBirthYear = dreamPartnerInfo.upperBirthYear {
            
            let isInitialState = String(lowerBirthYear) == self.lowerValue && String(upperBirthYear) == self.upperValue
            if isInitialState {
                return false
            }
        }
        return true
    }
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension EditDateProfileAgeRangeModel: EditDateProfileAgeRangeModel.Stateful {}

//MARK: - Actionable
protocol EditDateProfileAgeRangeModelActionable: AnyObject {
    // content
    func setUpperValue(value: String?)
    func setLowerValue(value: String?)
    func setUserInfo(_ userInfo: UserInfo)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension EditDateProfileAgeRangeModel: EditDateProfileAgeRangeModelActionable {
    // content
    func setUpperValue(value: String?) {
        upperValue = value
    }
    func setLowerValue(value: String?) {
        lowerValue = value
    }
    func setUserInfo(_ userInfo: UserInfo) {
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
