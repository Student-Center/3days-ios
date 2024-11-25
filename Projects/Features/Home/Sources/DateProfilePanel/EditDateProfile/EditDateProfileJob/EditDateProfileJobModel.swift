//
//  EditDateProfileJobModel.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model
import DesignCore

final class EditDateProfileJobModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var userInfo: UserInfo? { get }
        var selectedJobs: [JobOccupation] { get }
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
    @Published var selectedJobs: [JobOccupation] = []
    
    var isValidated: Bool {
        let isInitial = selectedJobs.map { $0.rawValue } == userInfo?.dreamPartner.jobOccupations
        if isInitial {
            return false
        }
        if selectedJobs.isEmpty {
            return false
        }
        
        return true
    }
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension EditDateProfileJobModel: EditDateProfileJobModel.Stateful {}

//MARK: - Actionable
protocol EditDateProfileJobModelActionable: AnyObject {
    // content
    func setSelectedJobs(_ jobs: [JobOccupation])
    func setUserInfo(_ userInfo: UserInfo)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension EditDateProfileJobModel: EditDateProfileJobModelActionable {
    // content
    func setUserInfo(_ userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    func setSelectedJobs(_ jobs: [JobOccupation]) {
        self.selectedJobs = jobs
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
