//
//  RegionService.swift
//  CommonKit
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated
import Model

//MARK: - Service Protocol
public protocol RegionServiceProtocol {
    func requestMainRegions() async throws -> [String]
    func requestSubRegions(mainRegion: String) async throws -> [Components.Schemas.Location]
}

//MARK: - Service
public final class RegionService {
    public static var shared = RegionService()
    private init() {}
}

extension RegionService: RegionServiceProtocol {
    public func requestMainRegions() async throws -> [String] {
        let response = try await client.getLocationRegions().ok.body.json
        return response
    }
    
    public func requestSubRegions(mainRegion: String) async throws -> [Components.Schemas.Location] {
        let response = try await client.getLocationsByRegion(
            path: .init(regionName: mainRegion)
        ).ok.body.json
        return response
    }
}
