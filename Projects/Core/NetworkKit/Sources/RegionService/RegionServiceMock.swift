//
//  RegionServiceMock.swift
//  CommonKit
//
//  Created by 김지수 on 10/13/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated

public final class RegionServiceMock: RegionServiceProtocol {
    public init() {}
    
    public func requestMainRegions() async throws -> [String] {
        [
          "강원",
          "경기",
          "경남",
          "경북",
          "광주",
          "대구",
          "대전",
          "부산",
          "서울",
          "세종",
          "울산",
          "인천",
          "전남",
          "전북",
          "제주",
          "충남",
          "충북"
        ]
    }
    
    public func requestSubRegions(mainRegion: String) async throws -> [Components.Schemas.Location] {
        [
            "종로구",
            "중구",
            "용산구",
            "서초구",
            "강남구",
            "중랑구",
            "구구콘",
            "광진구",
            "은평구",
            "양천구",
            "금천구",
            "강서구",
            "영등포구",
            "송파구"
        ].map {
            Components.Schemas.Location(
                id: $0,
                region: mainRegion,
                subRegion: $0
            )
        }
    }
}
