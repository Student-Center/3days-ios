//
//  AuthCompanyTest.swift
//  SignUp-UnitTest
//
//  Created by 김지수 on 10/10/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import XCTest
@testable import SignUp
import Model
import NetworkKit
import CommonKit

class AuthCompanyTest: XCTestCase {
    var state: AuthCompanyModel!
    var intent: AuthCompanyIntent!
    
    override func setUp() {
        super.setUp()
        state = AuthCompanyModel()
        intent = AuthCompanyIntent(
            model: state,
            input: .init(),
            companyService: CompanyServiceMock()
        )
        intent.onAppear()
    }
    
    override func tearDown() {
        state = nil
        intent = nil
        super.tearDown()
    }
    
    func testCompanySelectionFlow() async {
        // 검색어가 없을 때는 request 하지 않음
        state.textInput = ""
        try? await Task.sleep(for: .seconds(1))
        XCTAssertEqual(
            state.searchResponse,
            []
        )
        
        state.textInput = "검색어"
        try? await Task.sleep(for: .seconds(1))

        // 선택
        intent.onCompanySelected(
            company: state.searchResponse[0]
        )
        // 선택했을 때는 validated 여야 함
        XCTAssertTrue(state.isValidated)
        XCTAssertEqual(
            state.selectedCompany?.name,
            state.textInput
        )
        // 다른 검색어가 들어왔을 때는 selection, validation 초기화
        state.textInput = "다른검색어"
        intent.onTextChanged(text: "다른검색어")
        XCTAssertEqual(
            state.isValidated,
            false
        )
        XCTAssertNil(state.selectedCompany)
    }
    
    func testNotExistMyCompanyToggle() async {
        state.textInput = "검색어"
        
        try? await Task.sleep(for: .seconds(1))
        // 선택
        intent.onCompanySelected(
            company: state.searchResponse[0]
        )
        // 여기 내 회사 없어요 체크
        intent.onTapNoCompanyToggle()
        XCTAssertEqual(
            state.isTextFieldFocused,
            false
        )
        XCTAssertEqual(
            state.isTextFieldEnabled,
            false
        )
        XCTAssertTrue(state.isValidated)
        // 선택했던 회사는 해제되어야 함
        XCTAssertNil(state.selectedCompany)
        
    }
}
