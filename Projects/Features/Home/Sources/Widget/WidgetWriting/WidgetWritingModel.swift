//
//  WidgetWritingModel.swift
//  Home
//
//  Created by 김지수 on 11/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import Model

final class WidgetWritingModel: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var selectedWidgetType: WidgetType? { get }
        var widgetBodyText: String { get set }
        var isValidated: Bool { get }
        var textMaxCount: Int { get }
        
        var isModalPresented: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var selectedWidgetType: WidgetType?
    @Published var widgetBodyText = String()
    @Published var isModalPresented: Bool = true
    var textMaxCount: Int = 40
    
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension WidgetWritingModel: WidgetWritingModel.Stateful {}

//MARK: - Actionable
protocol WidgetWritingModelActionable: AnyObject {
    // content
    func setBodyText(_ text: String)
    func setValidation(value: Bool)
    func setWidgetType(_ widget: WidgetType)
    func modalDismiss()

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension WidgetWritingModel: WidgetWritingModelActionable {
    // content
    func setBodyText(_ text: String) {
        widgetBodyText = text
    }
    func setValidation(value: Bool) {
        isValidated = value
    }
    func setWidgetType(_ widget: WidgetType) {
        selectedWidgetType = widget
    }
    func modalDismiss() {
        isModalPresented = false
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
