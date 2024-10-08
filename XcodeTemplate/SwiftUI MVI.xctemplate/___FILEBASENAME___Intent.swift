//___FILEHEADER___

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class ___FILEBASENAMEASIDENTIFIER___ {
    private weak var model: ___VARIABLE_productName___ModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: ___VARIABLE_productName___ModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension ___FILEBASENAMEASIDENTIFIER___ {
    protocol Intentable {
        // content
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
