//
//  EditDateProfileJobIntent.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import DesignCore
import Model
import NetworkKit

//MARK: - Intent
class EditDateProfileJobIntent {
    private weak var model: EditDateProfileJobModelActionable?
    private let input: DataModel
    private let profileService: ProfileServiceProtocol

    // MARK: Life cycle
    init(
        model: EditDateProfileJobModelActionable,
        input: DataModel,
        service: ProfileServiceProtocol = ProfileService.shared
    ) {
        self.input = input
        self.model = model
        self.profileService = service
        model.setUserInfo(input.userInfo)
        let selectedAllJobs = input.userInfo.dreamPartner
            .jobOccupations
            .compactMap { JobOccupation(rawValue: $0) }
        model.setSelectedJobs(selectedAllJobs)
    }
}

//MARK: - Intentable
extension EditDateProfileJobIntent {
    protocol Intentable {
        // content
        func onTapJobOccupation(
            selectedAllJobs: [JobOccupation],
            selectedJob: JobOccupation
        )
        func onTapNextButton(state: EditDateProfileJobModel.Stateful)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo
    }
}

//MARK: - Intentable
extension EditDateProfileJobIntent: EditDateProfileJobIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapJobOccupation(
        selectedAllJobs: [JobOccupation],
        selectedJob: JobOccupation
    ) {
        var result = selectedAllJobs
        if let index = result.firstIndex(where: { $0 == selectedJob }) {
            result.remove(at: index)
        } else {
            result.append(selectedJob)
        }
        model?.setSelectedJobs(result)
    }
    
    func onTapNextButton(state: EditDateProfileJobModel.Stateful) {
        Task {
            do {
                model?.setLoading(status: true)
                let jobOccupations = state.selectedJobs.map { $0.rawValue }
                var newUserInfo = input.userInfo
                newUserInfo.dreamPartner.jobOccupations = jobOccupations
                try await requestUpdateProfile(newUserInfo: newUserInfo)
                model?.setLoading(status: false)
                await MainActor.run {
                    AppCoordinator.shared.pop()
                }
            } catch {
                print(error)
                model?.setLoading(status: false)
                ToastHelper.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    func requestUpdateProfile(newUserInfo: UserInfo) async throws {
        try await profileService.requestPutPartnerInfo(userInfo: newUserInfo)
    }
}
