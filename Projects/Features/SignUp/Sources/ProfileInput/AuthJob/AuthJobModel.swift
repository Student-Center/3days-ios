//
//  AuthJobModel.swift
//  DesignPreview
//
//  Created by 김지수 on 10/17/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import DesignCore

final class AuthJobModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var selectedJobArray: [JobOccupation] { get }
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var selectedJobArray: [JobOccupation] = []
    var isValidated: Bool {
        selectedJobArray.isNotEmpty
    }
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension AuthJobModel: AuthJobModel.Stateful {}

//MARK: - Actionable
protocol AuthJobModelActionable: AnyObject {
    // content
    func setSelectedJobArray(_ jobs: [JobOccupation])
    
    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension AuthJobModel: AuthJobModelActionable {
    // content
    func setSelectedJobArray(_ jobs: [JobOccupation]) {
        selectedJobArray = jobs
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
