//
//  EditProfileRegionModel.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class EditProfileRegionModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var userInfo: UserInfo? { get }
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
    @Published var userInfo: UserInfo?
    @Published var mainRegions: [String] = []
    @Published var selectedMainRegion: String?
    
    @Published var subRegions: [RegionDomain] = []
    @Published var selectedSubRegions: [RegionDomain] = []
    
    var isValidated: Bool {
        let initialState = userInfo?.profile.locations.map { $0.id } == selectedSubRegions.map { $0.id }
        return selectedMainRegion != nil && selectedSubRegions.isNotEmpty && !initialState
    }
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension EditProfileRegionModel: EditProfileRegionModel.Stateful {}

//MARK: - Actionable
protocol EditProfileRegionModelActionable: AnyObject {
    // content
    func setUserInfo(_ userInfo: UserInfo)
    func setMainRegions(_ regions: [String])
    func setSelectedMainRegion(_ region: String)
    func setSubRegions(_ subRegions: [RegionDomain])
    func setSelectedSubRegion(_ subRegions: [RegionDomain])

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension EditProfileRegionModel: EditProfileRegionModelActionable {
    // content
    func setUserInfo(_ userInfo: UserInfo) {
        self.userInfo = userInfo
    }
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
