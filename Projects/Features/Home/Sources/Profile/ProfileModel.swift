//
//  ProfileModel.swift
//  DesignPreview
//
//  Created by 김지수 on 11/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class ProfileModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var isPresentedAddWidgetModal: Bool { get set }
        var isPresentedModifyWidgetView: Bool { get set }
        var isPresentedDeleteConfirmSheet: Bool { get set }
        var selectedWidgetType: ProfileWidget? { get }
        
        var userInfoModel: UserInfo? { get set }
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var userInfoModel: UserInfo?
    @Published var isPresentedAddWidgetModal: Bool = false
    @Published var isPresentedModifyWidgetView: Bool = false
    @Published var isPresentedDeleteConfirmSheet: Bool = false
    var selectedWidgetType: ProfileWidget?
    
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension ProfileModel: ProfileModel.Stateful {}

//MARK: - Actionable
protocol ProfileModelActionable: AnyObject {
    // content
    func setAddWidgetModalPresented(_ isPresented: Bool)
    func setModifyWidgetViewPresented(_ isPresented: Bool)
    func setDeleteConfirmSheetPresented(_ isPresented: Bool)
    func setUserInfo(_ userInfo: UserInfo)
    func setValidation(value: Bool)
    func setSelectedWidget(_ widget: ProfileWidget)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension ProfileModel: ProfileModelActionable {
    // content
    func setAddWidgetModalPresented(_ isPresented: Bool) {
        isPresentedAddWidgetModal = isPresented
    }
    func setModifyWidgetViewPresented(_ isPresented: Bool) {
        isPresentedModifyWidgetView = isPresented
    }
    func setDeleteConfirmSheetPresented(_ isPresented: Bool) {
        isPresentedDeleteConfirmSheet = isPresented
    }
    func setUserInfo(_ userInfo: UserInfo) {
        userInfoModel = userInfo
    }
    func setValidation(value: Bool) {
        isValidated = value
    }
    func setSelectedWidget(_ widget: ProfileWidget) {
        selectedWidgetType = widget
    }
    
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
