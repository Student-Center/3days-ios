//
//  DesignCoreTest.swift
//  DesignCore-UnitTest
//
//  Created by 김지수 on 9/14/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import XCTest
@testable import DesignCore

final class DesignCoreTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFontImport() {
        let pretendard = UIFont.pretendard(._600, size: 20)
        XCTAssertEqual(pretendard.familyName, "Pretendard")
        let robotoSlab = UIFont.robotoSlab(size: 20)
        XCTAssertEqual(robotoSlab.familyName, "Roboto Slab")
    }
    
    func testTypography() {
        /// en-typo 는 pretendardWeight 를 가져선 안됨
        let enTypo = [Typography.en_medium_16, Typography.en_medium_20]
        let enPretendardWeight = enTypo
            .compactMap { $0.pretendardWeight }
        XCTAssertEqual(enPretendardWeight, [])
        
        /// pretendard typo 는 pretendardWeight 를 항상 가지고 있어야 함
        let pretendardTypos = Typography.allCases
            .filter { typo in
                !enTypo.contains { $0 == typo }
            }
            .compactMap { $0.pretendardWeight }
        
        let pretendardCount = Typography.allCases.count - enTypo.count
        XCTAssertEqual(pretendardTypos.count, pretendardCount)
    }
}
