//
//  AuthCompanyIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CommonKit
import Combine
import CoreKit
import Model
import NetworkKit

//MARK: - Intent
class AuthCompanyIntent {
    private weak var model: AuthCompanyModelActionable?
    private let input: DataModel
    private let companyService: CompanyServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: Life cycle
    init(
        model: AuthCompanyModelActionable,
        input: DataModel,
        companyService: CompanyServiceProtocol = CompanyService.shared
    ) {
        self.input = input
        self.model = model
        self.companyService = companyService
    }
}

//MARK: - Intentable
extension AuthCompanyIntent {
    protocol Intentable {
        // content
        func onTextChanged(text: String)
        func onCompanySelected(company: CompanySearchResponse)
        func onTapNoCompanyToggle()
        func onTapNextButton()
        func onChangedFocusState(_ value: Bool)
        func onTapSameCompanyMatching(isAgree: Bool)
        func needRequestNextPage(
            keyword: String,
            next: String
        )
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension AuthCompanyIntent: AuthCompanyIntent.Intentable {
    // default
    func onAppear() {
        if let model = model as? AuthCompanyModel {
            model.$textInput
                .removeDuplicates()
                .debounce(
                    for: .seconds(0.75),
                    scheduler: RunLoop.main
                )
                .sink { [weak self] text in
                    Task { [weak self] in
                        await self?.searchCompanyData(
                            keyword: text
                        )
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func task() async {}
    
    // content
    func onChangedFocusState(_ value: Bool) {
        model?.setFocusState(value)
    }
    func onTapNoCompanyToggle() {
        model?.setToggleNoCompany()
    }
    func onTextChanged(text: String) {
        if let model = model as? AuthCompanyModel,
           model.selectedCompany?.name != text {
            model.setSelectedCompany(nil)
        }
    }
    func onCompanySelected(company: CompanySearchResponse) {
        model?.setSelectedCompany(company)
    }
    func searchCompanyData(keyword: String) async {
        guard keyword.count > 0 else {
            model?.setResponseData([])
            model?.setSelectedCompany(nil)
            return
        }
        await requestCompanyList(keyword: keyword, needAppend: false)
    }
    func onTapSameCompanyMatching(isAgree: Bool) {
        model?.setSameCompanyMatchingAvailable(isAgree)
    }
    func needRequestNextPage(
        keyword: String,
        next: String
    ) {
        Task {
            await requestCompanyList(
                keyword: keyword,
                next: next,
                needAppend: true
            )
        }
    }
    // company list API 요청
    func requestCompanyList(
        keyword: String,
        next: String? = nil,
        needAppend: Bool
    ) async {
        do {
            let (response, next) = try await companyService.requestSearchCompany(
                keyword: keyword,
                next: next
            )
            if needAppend {
                model?.appendResponseData(response)
            } else {
                model?.setResponseData(response)
            }
            model?.setNextPaginationKey(next)
        } catch {
            print(error)
        }
    }
    func onTapNextButton() {
        Task {
            await pushNextView()
        }
    }
    
    @MainActor
    func pushNextView() {
        AppCoordinator.shared.push(.signUp(.authName))
    }
}
