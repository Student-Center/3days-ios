//
//  EditDateProfileDistanceModel.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class EditDateProfileDistanceModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var userInfo: UserInfo? { get }
        var selectedDistanceType: DreamPartnerDistanceType? { get }
        var isValidated: Bool { get }
        var myRegionString: String { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var userInfo: UserInfo?
    @Published var selectedDistanceType: DreamPartnerDistanceType?
    var isValidated: Bool {
        if selectedDistanceType == nil {
            return false
        }
        if userInfo?.dreamPartner.distanceType == selectedDistanceType {
            return false
        }
        return true
    }
    
    var myRegionString: String {
        if let location = userInfo?.profile.locations {
            return location
                .compactMap { $0.name }
                .joined(separator: ", ")
        }
        return "-"
    }
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension EditDateProfileDistanceModel: EditDateProfileDistanceModel.Stateful {}

//MARK: - Actionable
protocol EditDateProfileDistanceModelActionable: AnyObject {
    // content
    func setUserInfo(_ userInfo: UserInfo)
    func setDistanceType(_ type: DreamPartnerDistanceType)
    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension EditDateProfileDistanceModel: EditDateProfileDistanceModelActionable {
    // content
    func setDistanceType(_ type: DreamPartnerDistanceType) {
        selectedDistanceType = type
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
