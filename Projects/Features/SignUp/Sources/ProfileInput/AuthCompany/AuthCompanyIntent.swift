//
//  AuthCompanyIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CommonKit
import CoreKit
import Model
import NetworkKit
import SearchCompany

//MARK: - Intent
class AuthCompanyIntent {
    private weak var model: AuthCompanyModelActionable?
    private let input: DataModel
    
    internal let searchCompanyIntent: SearchCompanyIntent.Intentable

    // MARK: Life cycle
    init(
        model: AuthCompanyModelActionable,
        input: DataModel,
        searchCompanyIntent: SearchCompanyIntent.Intentable
    ) {
        self.input = input
        self.model = model
        self.searchCompanyIntent = searchCompanyIntent
    }
}

//MARK: - Intentable
extension AuthCompanyIntent {
    protocol Intentable {
        var searchCompanyIntent: SearchCompanyIntent.Intentable { get }
        // content
        func onTapNextButton(state: SearchCompanyModel.Stateful)
        func showSameCompanyPopup()
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let input: SignUpFormDomain
    }
}

//MARK: - Intentable
extension AuthCompanyIntent: AuthCompanyIntent.Intentable {
    func onAppear() {
        searchCompanyIntent.setSameCompanyPopupHandler { [weak self] state in
            self?.onTapNextButton(state: state)
        }
    }
    
    func task() async {
        
    }
    
    func showSameCompanyPopup() {
        searchCompanyIntent.showSameCompanyPopup()
    }
    
    // default
    func onTapNextButton(state: SearchCompanyModel.Stateful) {
        Task {
            var payload = input.input
            payload.profile?.companyId = state.selectedCompany?.id
            payload.dreamPartner?.allowSameCompany = state.sameCompanyMatchingAvailable
            await pushNextView(payload: payload)
        }
    }
    
    @MainActor
    func pushNextView(payload: SignUpFormDomain) {
        AppCoordinator.shared.push(.signUp(.authJobOccupation(input: payload)))
    }
}
