//
//  AuthGreetingIntent.swift
//  SignUp
//
//  Created by 김지수 on 10/5/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class AuthGreetingIntent {
    private weak var model: AuthGreetingModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: AuthGreetingModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension AuthGreetingIntent {
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
extension AuthGreetingIntent: AuthGreetingIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {
        try? await Task.sleep(for: .milliseconds(500))
        model?.setIsAppeared(value: true)
    }
    
    // content
    func onTapNextButton() {}
}
