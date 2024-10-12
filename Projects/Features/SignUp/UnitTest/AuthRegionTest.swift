//
//  AuthRegionTest.swift
//  SignUp-UnitTest
//
//  Created by 김지수 on 10/13/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import XCTest
@testable import SignUp
import Model
import NetworkKit
import CommonKit

class AuthRegionTest: XCTestCase {
    var state: AuthRegionModel!
    var intent: AuthRegionIntent!
    
    override func setUp() {
        super.setUp()
        state = AuthRegionModel()
        intent = AuthRegionIntent(
            model: state,
            input: .init(),
            regionService: RegionServiceMock()
        )
    }
    
    func asyncInitialize() async {
        intent.onAppear()
        await intent.task()
    }
    
    override func tearDown() {
        state = nil
        intent = nil
        super.tearDown()
    }

    func testMainRegionSelection() async throws {
        await asyncInitialize()
        
        intent.onTapMainRegion("경기")
        try await Task.sleep(for: .seconds(1.0))
        XCTAssertEqual("경기", state.selectedMainRegion)
    }
    
    func testSubRegionSelection() async throws {
        await asyncInitialize()
        guard state.subRegions.count > 10 else { return }
        
        let selectRegion1 = state.subRegions[5]
        let selectRegion2 = state.subRegions[6]
        let selectRegion3 = state.subRegions[7]
        
        // 탭 하면 데이터소스에 존재해야 함
        intent.onTapSubRegion(
            totalSubRegions: state.selectedSubRegions,
            selectedSubRegion: selectRegion1
        )
        XCTAssertTrue(state.selectedSubRegions.contains(where: { $0.id == selectRegion1.id }))
        
        // 다시 탭 하면 데이터소스에서 빠져야 함
        intent.onTapSubRegion(
            totalSubRegions: state.selectedSubRegions,
            selectedSubRegion: selectRegion1
        )
        XCTAssertFalse(state.selectedSubRegions.contains(where: { $0.id == selectRegion1.id }))
        
        intent.onTapSubRegion(
            totalSubRegions: state.selectedSubRegions,
            selectedSubRegion: selectRegion1
        )
        
        intent.onTapSubRegion(
            totalSubRegions: state.selectedSubRegions,
            selectedSubRegion: selectRegion2
        )
        
        intent.onTapSubRegion(
            totalSubRegions: state.selectedSubRegions,
            selectedSubRegion: selectRegion3
        )
        XCTAssertEqual(3, state.selectedSubRegions.count)
        
        intent.onTapSubRegion(
            totalSubRegions: state.selectedSubRegions,
            selectedSubRegion: selectRegion3
        )
        XCTAssertEqual(2, state.selectedSubRegions.count)
        XCTAssertFalse(state.selectedSubRegions.contains(where: { $0.id == selectRegion3.id }))
    }
    
    func testMaximumSelectionCount() async throws {
        await asyncInitialize()
        guard state.subRegions.count > 10 else { return }
        
        state.subRegions.forEach { region in
            intent.onTapSubRegion(
                totalSubRegions: state.selectedSubRegions,
                selectedSubRegion: region
            )
        }
        
        XCTAssertEqual(
            intent.maxSelectCount,
            state.selectedSubRegions.count
        )
    }
}
