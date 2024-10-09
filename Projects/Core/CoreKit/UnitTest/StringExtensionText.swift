//
//  StringExtensionText.swift
//  CoreKit-UnitTest
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import XCTest
@testable import CoreKit

final class PhoneNumberTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // 전화번호 검증 성공
    func testValidPhoneNumber() {
        // 유효한 번호 (하이픈 없는 11자리 번호)
        XCTAssertTrue(
            "01012345678".isValidPhoneNumber(),
            "유효한 번호 형식임에도 불구하고 false가 반환됨"
        )
    }
    
    // 전화번호 검증 실패
    func testInvalidPhoneNumber() {
        // 유효하지 않은 번호 (형식이 잘못된 경우)
        XCTAssertFalse(
            "01112345678".isValidPhoneNumber(),
            "유효하지 않은 번호 형식임에도 불구하고 true가 반환됨"
        )
        XCTAssertFalse(
            "0101234567".isValidPhoneNumber(),
            "유효하지 않은 번호 형식임에도 불구하고 true가 반환됨"
        )
        XCTAssertFalse(
            "010123456789".isValidPhoneNumber(),
            "유효하지 않은 번호 형식임에도 불구하고 true가 반환됨"
        )
        XCTAssertTrue(
            "010-1234-5678".isValidPhoneNumber(),
            "하이픈이 포함되었으나 유효한 번호인 경우 true를 반환해야 함"
        )
        
        // 텍스트가 포함된 경우
        XCTAssertFalse(
            "010a2345678".isValidPhoneNumber(),
            "문자가 포함된 경우에도 유효한 번호로 처리되고 있음"
        )
        XCTAssertFalse(
            "010123456a8".isValidPhoneNumber(),
            "끝에 문자가 포함된 경우에도 유효한 번호로 처리되고 있음"
        )
        XCTAssertFalse(
            "a1012345678".isValidPhoneNumber(),
            "번호 앞에 문자가 포함된 경우에도 유효한 번호로 처리되고 있음"
        )
    }
    
    // 전화번호 "-" 붙이기 케이스
    func testFormattedPhoneNumberAddHyphen() {
        XCTAssertEqual(
            "01012345678".formattedPhoneNumber(),
            "010-1234-5678",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        XCTAssertEqual(
            "010123456".formattedPhoneNumber(),
            "010-1234-56",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        XCTAssertEqual(
            "0104444".formattedPhoneNumber(),
            "010-4444",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        XCTAssertEqual(
            "010".formattedPhoneNumber(),
            "010",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        XCTAssertEqual(
            "01042".formattedPhoneNumber(),
            "010-42",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        XCTAssertEqual(
            "01".formattedPhoneNumber(),
            "01",
            "포맷된 번호가 예상과 다릅니다."
        )
        // 10자리 입력
        XCTAssertEqual(
            "0101234567".formattedPhoneNumber(),
            "010-1234-567",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        // 7자리 입력
        XCTAssertEqual(
            "0101234".formattedPhoneNumber(),
            "010-1234",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        // 6자리 입력
        XCTAssertEqual(
            "010123".formattedPhoneNumber(),
            "010-123",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        // 5자리 입력
        XCTAssertEqual(
            "01012".formattedPhoneNumber(),
            "010-12",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        // 4자리 입력
        XCTAssertEqual(
            "0101".formattedPhoneNumber(),
            "010-1",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        // 3자리 입력
        XCTAssertEqual(
            "010".formattedPhoneNumber(),
            "010",
            "포맷된 번호가 예상과 다릅니다."
        )
        
        // 2자리 이하 입력
        XCTAssertEqual(
            "01".formattedPhoneNumber(),
            "01",
            "포맷된 번호가 예상과 다릅니다."
        )
        XCTAssertEqual(
            "0".formattedPhoneNumber(),
            "0",
            "포맷된 번호가 예상과 다릅니다."
        )
    }
}
