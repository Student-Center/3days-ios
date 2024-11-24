//
//  EditProfileRegionIntent.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import NetworkKit
import Model
import DesignCore

//MARK: - Intent
class EditProfileRegionIntent {
    private weak var model: EditProfileRegionModelActionable?
    private let input: DataModel
    private let regionService: RegionServiceProtocol
    private let profileService: ProfileServiceProtocol
    let maxSelectCount = 10
    
    // MARK: Life cycle
    init(
        model: EditProfileRegionModelActionable,
        input: DataModel,
        regionService: RegionServiceProtocol = RegionService.shared,
        profileService: ProfileServiceProtocol = ProfileService.shared
    ) {
        self.input = input
        self.model = model
        self.regionService = regionService
        self.profileService = profileService
        model.setUserInfo(input.userInfo)
        
        let selectedRegion = input.userInfo.profile.locations.map {
            RegionDomain(
                id: $0.id,
                mainRegion: "",
                subRegion: $0.name
            )
        }
        model.setSelectedSubRegion(selectedRegion)
    }
}

//MARK: - Intentable
extension EditProfileRegionIntent {
    protocol Intentable {
        // content
        func onTapNextButton(state: EditProfileRegionModel.Stateful)
        func onTapMainRegion(_ region: String)
        func onTapSubRegion(
            totalSubRegions: [RegionDomain],
            selectedSubRegion: RegionDomain
        )
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo
    }
}

//MARK: - Intentable
extension EditProfileRegionIntent: EditProfileRegionIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {
        model?.setLoading(status: true)
        let mainRegions = await requestMainRegions()
        fetchMainRegions(mainRegions)
        guard mainRegions.isNotEmpty else { return }
        onTapMainRegion(mainRegions[0])
        let subRegions = await requestSubRegions(mainRegion: mainRegions[0])
        fetchSubRegions(subRegions)
        model?.setLoading(status: false)
    }
    
    func onTapMainRegion(_ region: String) {
        model?.setSelectedMainRegion(region)
        model?.setSubRegions([])
        Task {
            let subRegions = await requestSubRegions(mainRegion: region)
            fetchSubRegions(subRegions)
        }
    }
    
    func onTapSubRegion(
        totalSubRegions: [RegionDomain],
        selectedSubRegion: RegionDomain
    ) {
        var result = totalSubRegions
        
        if let index = totalSubRegions
            .firstIndex(where: { $0.id == selectedSubRegion.id }) {
            result.remove(at: index)
        } else {
            // 갯수 10개 제한
            guard result.count < maxSelectCount else { return }
            result.append(selectedSubRegion)
        }
        model?.setSelectedSubRegion(result)
    }
    
    func requestMainRegions() async -> [String] {
        do {
            return try await regionService.requestMainRegions()
        } catch {
            print(error)
            return []
        }
    }
    
    func fetchMainRegions(_ mainRegions: [String]) {
        model?.setMainRegions(mainRegions)
    }
    
    func requestSubRegions(mainRegion: String) async -> [RegionDomain] {
        do {
            return try await regionService.requestSubRegions(mainRegion: mainRegion)
                .map { RegionDomain(dto: $0) }
            
        } catch {
            print(error)
            return []
        }
    }
    
    func fetchSubRegions(_ subRegions: [RegionDomain]) {
        model?.setSubRegions(subRegions)
    }
    
    // content
    func onTapNextButton(state: EditProfileRegionModel.Stateful) {
        Task {
            do {
                guard let userInfo = state.userInfo else { return }
                model?.setLoading(status: true)
                var newUserInfo = userInfo
                let newRegions = state.selectedSubRegions.map { LocationModel(id: $0.id, name: $0.subRegion) }
                newUserInfo.profile.locations = newRegions
                try await requestUpdateProfile(newUserInfo: newUserInfo)
                model?.setLoading(status: false)
                await MainActor.run {
                    AppCoordinator.shared.pop()
                }
            } catch {
                print(error)
                ToastHelper.showErrorMessage(error.localizedDescription)
                model?.setLoading(status: false)
            }
        }
    }
    
    func requestUpdateProfile(newUserInfo: UserInfo) async throws {
        try await profileService.requestPutUserInfo(userInfo: newUserInfo)
    }
}
