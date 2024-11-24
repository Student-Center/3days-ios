//
//  SearchCompanyModel.swift
//  SearchCompany
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model
import DesignCore

extension CompanySearchResponse: DropDownFetchable {
    public static func == (lhs: CompanySearchResponse, rhs: CompanySearchResponse) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
}

public final class SearchCompanyModel: ObservableObject {
    
    //MARK: Stateful
    public protocol Stateful {
        // content
        var searchResponse: [CompanySearchResponse] { get }
        var nextSearchKey: String? { get }
        var needPagination: Bool { get }
        var selectedCompany: CompanySearchResponse? { get }
        var isNoCompanyHere: Bool { get }
        var textInput: String { get set }
        var isValidated: Bool { get }
        var isTextFieldFocused: Bool { get }
        var isTextFieldEnabled: Bool { get }
        var sameCompanyMatchingAvailable: Bool? { get }
        var isShowSameCompanyPopup: Bool { get set }
                
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published public var searchResponse: [CompanySearchResponse] = []
    public var nextSearchKey: String? = nil
    @Published public var selectedCompany: CompanySearchResponse? = nil
    @Published public var textInput: String = ""
    @Published public var isNoCompanyHere: Bool = false
    @Published public var isTextFieldFocused: Bool = false
    @Published public var isTextFieldEnabled: Bool = true
    @Published public var sameCompanyMatchingAvailable: Bool?
    @Published public var isShowSameCompanyPopup: Bool = false
    
    public var needPagination: Bool {
        return nextSearchKey != nil
    }
    
    public var isValidated: Bool {
        if isNoCompanyHere {
            return true
        } else {
            return selectedCompany != nil
        }
    }
    
    // default
    @Published public var isLoading: Bool = false
    
    // error
    @Published public var showErrorView: ErrorModel?
    @Published public var showErrorAlert: ErrorModel?
    
    public init() {}
}

extension SearchCompanyModel: SearchCompanyModel.Stateful {}

//MARK: - Actionable
public protocol SearchCompanyModelActionable: AnyObject {
    // content
    func setResponseData(_ response: [CompanySearchResponse])
    func appendResponseData(_ response: [CompanySearchResponse])
    func setNextPaginationKey(_ next: String?)
    func setSelectedCompany(_ company: CompanySearchResponse?)
    func setToggleNoCompany()
    func setFocusState(_ value: Bool)
    func setSameCompanyMatchingAvailable(_ value: Bool)
    func showSameCompanyPopup(isShow: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension SearchCompanyModel: SearchCompanyModelActionable {
    public func setResponseData(_ response: [CompanySearchResponse]) {
        searchResponse = response
    }
    public func appendResponseData(_ response: [CompanySearchResponse]) {
        searchResponse.append(contentsOf: response)
    }
    public func setNextPaginationKey(_ next: String?) {
        nextSearchKey = next
    }
    public func setSelectedCompany(_ company: CompanySearchResponse?) {
        selectedCompany = company
        if let company {
            textInput = company.name
        }
    }
    public func setSameCompanyMatchingAvailable(_ value: Bool) {
        sameCompanyMatchingAvailable = value
    }
    public func setFocusState(_ value: Bool) {
        isTextFieldFocused = value
    }
    public func setToggleNoCompany() {
        isNoCompanyHere.toggle()
        
        // on 이 된다면
        if isNoCompanyHere {
            selectedCompany = nil
            textInput = ""
            isTextFieldFocused = false
            isTextFieldEnabled = false
        } else {
            isTextFieldEnabled = true
        }
    }
    public func showSameCompanyPopup(isShow: Bool) {
        isShowSameCompanyPopup = isShow
    }
    
    // default
    public func setLoading(status: Bool) {
        isLoading = status
    }
    
    // error
    public func showErrorView(error: ErrorModel) {
        showErrorView = error
    }
    public func showErrorAlert(error: ErrorModel) {
        showErrorAlert = error
    }
    public func resetError() {
        showErrorView = nil
        showErrorAlert = nil
    }
}
