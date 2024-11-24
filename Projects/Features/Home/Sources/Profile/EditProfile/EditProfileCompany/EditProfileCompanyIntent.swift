//
//  EditProfileCompanyIntent.swift
//  SignUp
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model
import NetworkKit
import SearchCompany

//MARK: - Intent
class EditProfileCompanyIntent {
    private weak var model: EditProfileCompanyModelActionable?
    private let input: DataModel
    private let profileService: ProfileServiceProtocol
    
    internal let searchCompanyIntent: SearchCompanyIntent.Intentable

    // MARK: Life cycle
    init(
        model: EditProfileCompanyModelActionable,
        input: DataModel,
        searchCompanyIntent: SearchCompanyIntent.Intentable,
        profileService: ProfileServiceProtocol = ProfileService.shared
    ) {
        self.input = input
        self.model = model
        self.searchCompanyIntent = searchCompanyIntent
        self.profileService = profileService
        model.setUserInfo(userInfo: input.userInfo)
    }
}

//MARK: - Intentable
extension EditProfileCompanyIntent {
    protocol Intentable {
        // content
        var searchCompanyIntent: SearchCompanyIntent.Intentable { get }
        func onTapNextButton(state: SearchCompanyModel.Stateful)
        func showSameCompanyPopup()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo
    }
}

//MARK: - Intentable
extension EditProfileCompanyIntent: EditProfileCompanyIntent.Intentable {
    // default
    func onAppear() {
        searchCompanyIntent.setSameCompanyPopupHandler { [weak self] state in
            self?.onTapNextButton(state: state)
        }
    }
    
    func task() async {}
    
    // content
    func onTapNextButton(
        state: SearchCompanyModel.Stateful
    ) {
        Task {
            do {
                guard let company = state.selectedCompany else { return }
                model?.setLoading(status: true)
                var newUserInfo = input.userInfo
                newUserInfo.profile.companyId = company.id
                newUserInfo.dreamPartner.allowSameCompany = state.sameCompanyMatchingAvailable
                try await requestPutProfile(newUserInfo: newUserInfo)
                model?.setLoading(status: false)
                await popView()
            } catch {
                model?.setLoading(status: false)
            }
        }
    }
    
    func showSameCompanyPopup() {
        searchCompanyIntent.showSameCompanyPopup()
    }
    
    func requestPutProfile(newUserInfo: UserInfo) async throws {
        try await profileService.requestPutUserInfo(userInfo: newUserInfo)
    }
    
    @MainActor
    func popView() {
        AppCoordinator.shared.pop()
    }
}
