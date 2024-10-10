//
//  AuthCompanyModel.swift
//  DesignPreview
//
//  Created by 김지수 on 10/9/24.
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

final class AuthCompanyModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
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
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var searchResponse: [CompanySearchResponse] = []
    var nextSearchKey: String? = nil
    @Published var selectedCompany: CompanySearchResponse? = nil
    @Published var textInput: String = ""
    @Published var isNoCompanyHere: Bool = false
    @Published var isTextFieldFocused: Bool = false
    @Published var isTextFieldEnabled: Bool = true
    @Published var sameCompanyMatchingAvailable: Bool?
    
    var needPagination: Bool {
        return nextSearchKey != nil
    }
    
    var isValidated: Bool {
        if isNoCompanyHere {
            return true
        } else {
            return selectedCompany != nil
        }
    }
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension AuthCompanyModel: AuthCompanyModel.Stateful {}

//MARK: - Actionable
protocol AuthCompanyModelActionable: AnyObject {
    // content
    func setResponseData(_ response: [CompanySearchResponse])
    func appendResponseData(_ response: [CompanySearchResponse])
    func setNextPaginationKey(_ next: String?)
    func setSelectedCompany(_ company: CompanySearchResponse?)
    func setToggleNoCompany()
    func setValidation(value: Bool)
    func setFocusState(_ value: Bool)
    func setSameCompanyMatchingAvailable(_ value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension AuthCompanyModel: AuthCompanyModelActionable {
    // content
    func setResponseData(_ response: [CompanySearchResponse]) {
        searchResponse = response
    }
    func appendResponseData(_ response: [CompanySearchResponse]) {
        searchResponse.append(contentsOf: response)
    }
    func setNextPaginationKey(_ next: String?) {
        nextSearchKey = next
    }
    func setSelectedCompany(_ company: CompanySearchResponse?) {
        selectedCompany = company
        if let company {
            textInput = company.name
        }
    }
    func setSameCompanyMatchingAvailable(_ value: Bool) {
        sameCompanyMatchingAvailable = value
    }
    func setFocusState(_ value: Bool) {
        isTextFieldFocused = value
    }
    func setToggleNoCompany() {
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
    func setValidation(value: Bool) {}
    
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
