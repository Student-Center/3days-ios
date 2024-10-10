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
    func requestSearchCompany(
        keyword: String,
        next: String?
    ) async throws -> ([CompanySearchResponse], String?)
}

//MARK: - Service
public final class CompanyService {
    public static var shared = CompanyService()
    private init() {}
}

extension CompanyService: CompanyServiceProtocol {
    public func requestSearchCompany(
        keyword: String,
        next: String? = nil
    ) async throws -> ([CompanySearchResponse], String?) {
        let response = try await client.searchCompanies(
            query: .init(name: keyword, next: next)
        ).ok.body.json
        
        let result = response.companies.map {
            CompanySearchResponse(
                id: $0.id,
                name: $0.name
            )
        }
        let next = response.next
        return (result, next)
    }
}
