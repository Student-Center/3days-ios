//
//  SearchCompanyIntent.swift
//  SearchCompany
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CommonKit
import Combine
import CoreKit
import Model
import NetworkKit

//MARK: - Intent
public class SearchCompanyIntent {
    private weak var model: SearchCompanyModelActionable?
    private let input: DataModel
    private let companyService: CompanyServiceProtocol
    public var sameCompanyPopupHandler: ((SearchCompanyModel.Stateful) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: Life cycle
    public init(
        model: SearchCompanyModelActionable,
        input: DataModel,
        companyService: CompanyServiceProtocol = CompanyService.shared
    ) {
        self.input = input
        self.model = model
        self.companyService = companyService
    }
}

//MARK: - Intentable
extension SearchCompanyIntent {
    public protocol Intentable {
        // content
        func onTextChanged(text: String)
        func onCompanySelected(company: CompanySearchResponse)
        func onTapNoCompanyToggle()
        func onChangedFocusState(_ value: Bool)
        func onTapSameCompanyMatching(isAgree: Bool)
        func needRequestNextPage(
            keyword: String,
            next: String
        )
        func showSameCompanyPopup()
        func closeSameCompanyPopup()
        func onTapNextButton(state: SearchCompanyModel.Stateful)
        func setSameCompanyPopupHandler(handler: @escaping (SearchCompanyModel.Stateful) -> Void)
        
        // default
        func onAppear()
        func task() async
    }
    
    public struct DataModel {
        public init() {}
    }
}

//MARK: - Intentable
extension SearchCompanyIntent: SearchCompanyIntent.Intentable {
    
    // default
    public func onAppear() {
        if let model = model as? SearchCompanyModel {
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
        
        onChangedFocusState(true)
    }
    
    public func task() async {}
    
    // content
    public func showSameCompanyPopup() {
        model?.showSameCompanyPopup(isShow: true)
    }
    public func closeSameCompanyPopup() {
        model?.showSameCompanyPopup(isShow: false)
    }
    public func onChangedFocusState(_ value: Bool) {
        model?.setFocusState(value)
    }
    public func onTapNoCompanyToggle() {
        model?.setToggleNoCompany()
    }
    public func onTextChanged(text: String) {
        if let model = model as? SearchCompanyModel,
           model.selectedCompany?.name != text {
            model.setSelectedCompany(nil)
        }
    }
    public func onCompanySelected(company: CompanySearchResponse) {
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
    public func onTapSameCompanyMatching(isAgree: Bool) {
        model?.setSameCompanyMatchingAvailable(isAgree)
    }
    public func needRequestNextPage(
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
    
    public func setSameCompanyPopupHandler(handler: @escaping (SearchCompanyModel.Stateful) -> Void) {
        sameCompanyPopupHandler = handler
    }
    
    public func onTapNextButton(state: any SearchCompanyModel.Stateful) {
        sameCompanyPopupHandler?(state)
    }
}
