//
//  ProfileService.swift
//  CommonKit
//
//  Created by 김지수 on 11/14/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CoreKit
import OpenapiGenerated
import Model

public protocol ProfileServiceProtocol {
    func requestPutProfileWidget(
        widgetType: Components.Schemas.ProfileWidgetType,
        content: String
    ) async throws
    
    func requestDeleteProfileWidget(
        widgetType: Components.Schemas.ProfileWidgetType
    ) async throws
    
    func requestPutUserInfo(userInfo: UserInfo) async throws
    
    func requestPutPartnerInfo(userInfo: UserInfo) async throws
}

public final class ProfileService {
    public static let shared = ProfileService()
    private init() {}
}

extension ProfileService: ProfileServiceProtocol {
    public func requestPutProfileWidget(
        widgetType: Components.Schemas.ProfileWidgetType,
        content: String
    ) async throws {
        let result = try await client.putProfileWidget(
            body: .json(
                .init(
                    _type: widgetType,
                    content: content
                )
            )
        )
        let _ = try result.ok
    }
    
    public func requestDeleteProfileWidget(
        widgetType: Components.Schemas.ProfileWidgetType
    ) async throws {
        let response = try await client.deleteProfileWidget(
            .init(
                path: .init(_type: widgetType)
            )
        )
        _ = try response.noContent
    }
    
    public func requestPutUserInfo(userInfo: UserInfo) async throws {
        guard let jobOccupation = userInfo.profile.jobOccupationDTO else {
            return
        }
        let result = try await client.updateMyUserInfo(
            .init(
                body: .json(
                    .init(
                        name: userInfo.name,
                        jobOccupation: jobOccupation,
                        companyId: userInfo.profile.companyId,
                        allowSameCompany: userInfo.dreamPartner.allowSameCompany,
                        locationIds: userInfo.profile.locations.map { $0.id }
                    )
                )
            )
        )
        _ = try result.ok
    }
    
    public func requestPutPartnerInfo(userInfo: UserInfo) async throws {
        let dreamPartner = userInfo.dreamPartner
        let jobOccupations = dreamPartner.jobOccupations
            .compactMap { Components.Schemas.JobOccupation(rawValue: $0) }
        
        let result = try await client.updateMyDesiredPartner(
            .init(
                body: .json(
                    .init(
                        birthYearRange: .init(
                            start: dreamPartner.lowerBirthYear,
                            end: dreamPartner.upperBirthYear
                        ),
                        jobOccupations: jobOccupations,
                        preferDistance: dreamPartner.distanceType.toDto
                    )
                )
            )
        )
        _ = try result.ok
        return
    }
}
