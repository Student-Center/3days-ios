//
//  WidgetSelectionModel.swift
//  Home
//
//  Created by 김지수 on 11/10/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class WidgetSelectionModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var isModalPresented: Bool { get set }
        var isPushWriteContentView: Bool { get set }
        var isValidated: Bool { get }
        var selectedWidget: WidgetType? { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var isModalPresented: Bool = false
    @Published var isPushWriteContentView: Bool = false
    @Published var isValidated: Bool = false
    @Published var selectedWidget: WidgetType?
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension WidgetSelectionModel: WidgetSelectionModel.Stateful {}

//MARK: - Actionable
protocol WidgetSelectionModelActionable: AnyObject {
    // content
    func setModalPresented(status: Bool)
    func setPushWriteContentView(status: Bool)
    func setValidation(value: Bool)
    func setSelectedWidget(widget: WidgetType)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension WidgetSelectionModel: WidgetSelectionModelActionable {
    // content
    func setModalPresented(status: Bool) {
        isModalPresented = status
    }
    func setPushWriteContentView(status: Bool) {
        isPushWriteContentView = status
    }
    func setSelectedWidget(widget: WidgetType) {
        selectedWidget = widget
    }
    func setValidation(value: Bool) {
        isValidated = value
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
