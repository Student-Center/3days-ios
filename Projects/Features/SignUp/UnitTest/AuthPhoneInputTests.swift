//
//  AuthPhoneInputTests.swift
//  DesignPreview
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import XCTest
@testable import SignUp
import Model

class AuthPhoneInputTests: XCTestCase {
    var model: AuthPhoneInputModel!
    var intent: AuthPhoneInputIntent!
    
    override func setUp() {
        super.setUp()
        model = AuthPhoneInputModel()
        intent = AuthPhoneInputIntent(
            model: model,
            input: .init()
        )
    }
    
    override func tearDown() {
        model = nil
        intent = nil
        super.tearDown()
    }
    
    func testOnChangePhoneInput() {
        // Given
        let validPhone = "01012345678"
        let invalidPhone = "010"

        intent.onChangePhoneInput(phone: validPhone)
        XCTAssertTrue(model.isPhoneValidated)
        
        intent.onChangePhoneInput(phone: invalidPhone)
        XCTAssertFalse(model.isPhoneValidated)
    }
    
    func testOnTapNextButton() async {
        let validPhone = "01012345678"
        intent.onChangePhoneInput(phone: validPhone)
        
        intent.onTapNextButton(with: validPhone)
        XCTAssertTrue(model.isLoading)
    }
    
    func testOnResponseAPI() async {
        let validPhone = "01012345678"
        let mock = SMSSendResponse(
            userType: .NEW,
            authCodeId: "abcd",
            phoneNumber: validPhone
        )
        await intent.onReceivedSMSResponse(mock)
    }
}
