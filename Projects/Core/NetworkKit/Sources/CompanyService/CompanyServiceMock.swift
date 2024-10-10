//
//  CompanyServiceMock.swift
//  CommonKit
//
//  Created by 김지수 on 10/10/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import Model

//MARK: - Service
public final class CompanyServiceMock: CompanyServiceProtocol {

    public init() {}
    
    public func requestSearchCompany(keyword: String, next: String?) async throws -> ([Model.CompanySearchResponse], String?) {
        return ([
            .init(id: "0", name: "현대글로비스"),
            .init(id: "1", name: "현대자동차"),
            .init(id: "2", name: "기아자동차"),
            .init(id: "3", name: "채널톡"),
            .init(id: "4", name: "닥터다이어리"),
            .init(id: "5", name: "컬쳐커넥션"),
            .init(id: "6", name: "엄청좋은회사"),
            .init(id: "7", name: "로지텍"),
            .init(id: "8", name: "스탠리"),
            .init(id: "9", name: "스타벅스"),
            .init(id: "10", name: "호날두주식회사"),
            .init(id: "11", name: "애플"),
            .init(id: "12", name: "엔비디아"),
        ], nil)
    }
}
