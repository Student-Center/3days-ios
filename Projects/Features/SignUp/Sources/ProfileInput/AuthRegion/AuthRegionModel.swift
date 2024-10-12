//
//  AuthRegionModel.swift
//  SignUp
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import SignUpDomain

final class AuthRegionModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var mainRegions: [String] { get }
        var selectedMainRegion: String? { get }
        var subRegions: [RegionDomain] { get }
        var selectedSubRegions: [RegionDomain] { get }
        
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var mainRegions: [String] = []
    @Published var selectedMainRegion: String?
    
    @Published var subRegions: [RegionDomain] = []
    @Published var selectedSubRegions: [RegionDomain] = []
    
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension AuthRegionModel: AuthRegionModel.Stateful {}

//MARK: - Actionable
protocol AuthRegionModelActionable: AnyObject {
    // content
    func setMainRegions(_ regions: [String])
    func setSelectedMainRegion(_ region: String)
    func setSubRegions(_ subRegions: [RegionDomain])
    func setSelectedSubRegion(_ subRegions: [RegionDomain])
    func setValidation(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension AuthRegionModel: AuthRegionModelActionable {
    // content
    func setMainRegions(_ regions: [String]) {
        mainRegions = regions
    }
    func setSelectedMainRegion(_ region: String) {
        selectedMainRegion = region
    }
    func setSubRegions(_ subRegions: [RegionDomain]) {
        self.subRegions = subRegions
    }
    func setSelectedSubRegion(_ subRegions: [RegionDomain]) {
        self.selectedSubRegions = subRegions
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
