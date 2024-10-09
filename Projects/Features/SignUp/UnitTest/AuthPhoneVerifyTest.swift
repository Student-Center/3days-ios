//
//  AuthPhoneVerifyTest.swift
//  SignUp-UnitTest
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import XCTest
@testable import SignUp
import Model
import NetworkKit
import CommonKit

enum MockingError: Error {
    case mockError
}

class AuthPhoneVerifyTest: XCTestCase {
    var model: AuthPhoneVerifyModel!
    var intent: AuthPhoneVerifyIntent!
    
    override func setUp() {
        super.setUp()
        model = AuthPhoneVerifyModel()
        intent = AuthPhoneVerifyIntent(
            model: model,
            input: .init(
                smsResponse: .init(
                    userType: .NEW,
                    authCodeId: "AuthCode",
                    phoneNumber: "01012345678"
                )
            ),
            service: AuthServiceMock()
        )
    }
    
    override func tearDown() {
        model = nil
        intent = nil
        super.tearDown()
    }
    
    /// 6 자리가 들어왔을 때 자동으로 요청하는지
    func testOnChangeVerifyCode() {
        let inputCode = "123456"
        intent.onChangeVerifyCode(code: inputCode)
        XCTAssertTrue(model.isLoading)
    }
    
    func testOnChangeFocusState() {
        let focusedState = true
        intent.onChangeFocusState(focusedState)
        XCTAssertEqual(model.verifyTextFieldFocused, focusedState)
    }
    
    func testOnAppear() {
        intent.onAppear()
        XCTAssertTrue(model.verifyTextFieldFocused)
    }
    
    func testVerificationResult() {
        let homePath = intent.getNextPath(userType: .EXISTING)
        XCTAssertEqual(homePath, PathType.main)
        
        let signUpProcessPath = intent.getNextPath(userType: .NEW)
        XCTAssertEqual(signUpProcessPath, PathType.signUp(.authAgreement))
    }
    
    func testErrorReceivced() {
        intent.processError(error: MockingError.mockError)
        XCTAssertEqual(model.verifyCode, "")
        XCTAssertEqual(model.isLoading, false)
        XCTAssertEqual(model.verifyTextFieldFocused, true)
        XCTAssertNotNil(model.showErrorAlert)
        
        let inputCode = "123"
        intent.onChangeVerifyCode(code: inputCode)
        XCTAssertNil(model.showErrorAlert)
    }
}
