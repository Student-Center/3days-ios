//
//  EditProfileJobIntent.swift
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
import NetworkKit

//MARK: - Intent
class EditProfileJobIntent {
    private weak var model: EditProfileJobModelActionable?
    private let input: DataModel
    private let profileService: ProfileServiceProtocol

    // MARK: Life cycle
    init(
        model: EditProfileJobModelActionable,
        input: DataModel,
        service: ProfileServiceProtocol = ProfileService.shared
    ) {
        self.input = input
        self.model = model
        self.profileService = service
        model.setUserInfo(input.userInfo)
        if let job = JobOccupation(rawValue: input.userInfo.profile.jobOccupationRawValue) {
            model.setSingleSelectedJob(job)
        }
    }
}

//MARK: - Intentable
extension EditProfileJobIntent {
    protocol Intentable {
        // content
        func onTapJobOccupation(
            selectedJob: JobOccupation
        )
        func onTapNextButton(state: EditProfileJobModel.Stateful)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo
    }
}

//MARK: - Intentable
extension EditProfileJobIntent: EditProfileJobIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapJobOccupation(selectedJob: JobOccupation) {
        model?.setSingleSelectedJob(selectedJob)
    }
    
    func onTapNextButton(state: EditProfileJobModel.Stateful) {
        Task {
            do {
                guard let userInfo = state.userInfo else { return }
                var newUserInfo = userInfo
                newUserInfo.profile.jobOccupationRawValue = state.singleSelectedJob!.rawValue
                model?.setLoading(status: true)
                try await requestEditProfile(newUserInfo: newUserInfo)
                await popToRoot()
            } catch {
                ToastHelper.showErrorMessage(error.localizedDescription)
                model?.setLoading(status: false)
            }
        }
    }
    
    func requestEditProfile(newUserInfo: UserInfo) async throws {
        
        try await profileService.requestPutUserInfo(
            userInfo: newUserInfo
        )
    }
    
    @MainActor
    func popToRoot() {
        AppCoordinator.shared.pop()
    }
}
