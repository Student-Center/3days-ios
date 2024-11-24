//
//  EditProfileJobModel.swift
//  SignUp
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import DesignCore
import Model

final class EditProfileJobModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var userInfo: UserInfo? { get }
        var singleSelectedJob: JobOccupation? { get }
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
    @Published var singleSelectedJob: JobOccupation?
    
    var isValidated: Bool {
        if let userInfo,
           let singleSelectedJob {
            if userInfo.profile.jobOccupationRawValue == singleSelectedJob.rawValue {
                return false
            }
        } else {
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

extension EditProfileJobModel: EditProfileJobModel.Stateful {}

//MARK: - Actionable
protocol EditProfileJobModelActionable: AnyObject {
    // content
    func setSingleSelectedJob(_ job: JobOccupation)
    func setUserInfo(_ userInfo: UserInfo)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension EditProfileJobModel: EditProfileJobModelActionable {
    // content
    func setUserInfo(_ userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    func setSingleSelectedJob(_ job: JobOccupation) {
        singleSelectedJob = job
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
