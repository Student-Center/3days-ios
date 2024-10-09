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
        var selectedCompany: CompanySearchResponse? { get }
        var textInput: String { get set }
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var searchResponse: [CompanySearchResponse] = []
    @Published var selectedCompany: CompanySearchResponse? = nil
    @Published var textInput: String = ""
//    @Published var isValidated: Bool = false
    
    var isValidated: Bool {
        selectedCompany != nil
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
    func setSelectedCompany(_ company: CompanySearchResponse?)
    func setValidation(value: Bool)

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
    func setSelectedCompany(_ company: CompanySearchResponse?) {
        selectedCompany = company
        if let company {
            textInput = company.name
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
