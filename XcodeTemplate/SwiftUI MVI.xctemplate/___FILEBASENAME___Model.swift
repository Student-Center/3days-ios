//___FILEHEADER___

import Foundation
import CommonKit
import CoreKit

final class ___FILEBASENAMEASIDENTIFIER___: ObservableObject {
    
    //MARK: Stateful
    protocol Stateful {
        // content
        var isValidated: Bool { get }
        
        // default
        var isLoading: Bool { get }
        
        // error
        var showErrorView: ErrorModel? { get }
        var showErrorAlert: ErrorModel? { get }
    }
    
    //MARK: State Properties
    // content
    @Published var isValidated: Bool = false
    
    // default
    @Published var isLoading: Bool = false
    
    // error
    @Published var showErrorView: ErrorModel?
    @Published var showErrorAlert: ErrorModel?
}

extension ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___.Stateful {}

//MARK: - Actionable
protocol ___FILEBASENAMEASIDENTIFIER___Actionable: AnyObject {
    // content
    func setValidation(value: Bool)

    // default
    func setLoading(status: Bool)
    
    // error
    func showErrorView(error: ErrorModel)
    func showErrorAlert(error: ErrorModel)
    func resetError()
}

extension ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___Actionable {
    // content
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
