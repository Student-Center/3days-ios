//
//  CoreKitTest.swift
//  CoreKit-UnitTest
//
//  Created by 김지수 on 8/17/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import XCTest
@testable import CoreKit

final class CoreKitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        ThisIsCoreKit.something()
        let result = ThisIsCoreKit.testFunctionSample()
        XCTAssertEqual(0, result)
    }
}
