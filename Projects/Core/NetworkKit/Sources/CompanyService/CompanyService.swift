//
//  CompanyService.swift
//  CommonKit
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated
import Model

//MARK: - Service Protocol
public protocol CompanyServiceProtocol {
    func requestSearchCompany(keyword: String) async throws -> [CompanySearchResponse]
}

//MARK: - Service
public final class CompanyService {
    public static var shared = CompanyService()
    private init() {}
}

extension CompanyService: CompanyServiceProtocol {
    public func requestSearchCompany(keyword: String) async throws -> [CompanySearchResponse] {
        let response = try await client.searchCompanies(
            query: .init(name: keyword)
        ).ok.body.json.companies
        
        return response.map {
            CompanySearchResponse(
                id: $0.id,
                name: $0.name
            )
        }
    }
}
