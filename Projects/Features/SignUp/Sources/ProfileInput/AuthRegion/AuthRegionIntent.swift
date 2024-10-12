//
//  AuthRegionIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import SignUpDomain
import NetworkKit

//MARK: - Intent
class AuthRegionIntent {
    private weak var model: AuthRegionModelActionable?
    private let input: DataModel
    private let regionService: RegionServiceProtocol
    let maxSelectCount = 10

    // MARK: Life cycle
    init(
        model: AuthRegionModelActionable,
        input: DataModel,
        regionService: RegionServiceProtocol = RegionService.shared
    ) {
        self.input = input
        self.model = model
        self.regionService = regionService
    }
}

//MARK: - Intentable
extension AuthRegionIntent {
    protocol Intentable {
        // content
        func onTapNextButton()
        func onTapMainRegion(_ region: String)
        func onTapSubRegion(
            totalSubRegions: [RegionDomain],
            selectedSubRegion: RegionDomain
        )
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension AuthRegionIntent: AuthRegionIntent.Intentable {
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
    func onTapNextButton() {}
    
    @MainActor
    func pushNextView() {
        AppCoordinator.shared.push(.signUp(.authName))
    }
}
