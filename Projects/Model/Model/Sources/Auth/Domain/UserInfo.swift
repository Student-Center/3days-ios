//
//  UserInfo.swift
//  Model
//
//  Created by 김지수 on 10/27/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated

public struct UserInfo {
    public let id: String?
    public let name: String
    public let phone: String
    public var profile: UserInfoProfile
    public var dreamPartner: DreamPartnerInfo
    public let profileWidgets: [ProfileWidget]
    
    public init(
        id: String,
        name: String,
        phone: String,
        profile: UserInfoProfile,
        dreamPartner: DreamPartnerInfo,
        profileWidgets: [ProfileWidget]
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.profile = profile
        self.dreamPartner = dreamPartner
        self.profileWidgets = profileWidgets
    }
    
    public init(from dto: Components.Schemas.GetMyUserInfoResponse) {
        self.id = dto.id
        self.name = dto.name
        self.phone = dto.phoneNumber
        self.profile = .init(from: dto.profile)
        self.dreamPartner = .init(from: dto.desiredPartner)
        self.profileWidgets = dto.profileWidgets.map { .init(from: $0) }
    }
    
    public static var mock: UserInfo {
        .init(
            id: UUID().uuidString,
            name: "김지수",
            phone: "01012341234",
            profile: .mock,
            dreamPartner: .mock,
            profileWidgets: ProfileWidget.mock
        )
    }
}

public struct UserInfoProfile {
    public let gender: GenderType
    public let birthYear: Int
    public let companyId: String?
    public var companyName: String?
    public let jobOccupation: String
    public var jobOccupationRawValue: String
    public var locations: [LocationModel]
    
    public var jobOccupationDTO: Components.Schemas.JobOccupation? {
        return .init(rawValue: jobOccupationRawValue)
    }

    public init(
        gender: GenderType,
        birthYear: Int,
        companyId: String?,
        companyName: String?,
        jobOccupation: String,
        jobOccupationRawValue: String,
        locations: [LocationModel]
    ) {
        self.gender = gender
        self.birthYear = birthYear
        self.companyId = companyId
        self.companyName = companyName
        self.jobOccupation = jobOccupation
        self.jobOccupationRawValue = jobOccupationRawValue
        self.locations = locations
    }
    
    public init(from dto: Components.Schemas.UserProfileDisplayInfo) {
        self.gender = dto.gender == .MALE ? .male : .female
        self.birthYear = dto.birthYear
        self.companyId = dto.company?.id
        self.companyName = dto.company?.display
        self.jobOccupation = dto.jobOccupation.display
        self.jobOccupationRawValue = dto.jobOccupation.code.rawValue
        self.locations = dto.locations.map {
            LocationModel(
                id: $0.id,
                name: $0.display
            )
        }
    }
    
    public static var mock: UserInfoProfile {
        .init(
            gender: .male,
            birthYear: 1980,
            companyId: nil,
            companyName: "현대자동차",
            jobOccupation: "IT",
            jobOccupationRawValue: "IT_INFORMATION",
            locations: LocationModel.mock
        )
    }
}

public struct DreamPartnerInfo {
    public let upperBirthYear: Int?
    public let lowerBirthYear: Int?
    public let jobOccupations: [String]
    public let distanceType: DreamPartnerDistanceType
    public let allowSameCompany: Bool?
    
    public init(
        upperBirthYear: Int?,
        lowerBirthYear: Int?,
        jobOccupations: [String],
        distanceType: DreamPartnerDistanceType,
        allowSameCompany: Bool?
    ) {
        self.upperBirthYear = upperBirthYear
        self.lowerBirthYear = lowerBirthYear
        self.jobOccupations = jobOccupations
        self.distanceType = distanceType
        self.allowSameCompany = allowSameCompany
    }
    
    public init(from dto: Components.Schemas.UserDesiredPartner) {
        self.upperBirthYear = dto.birthYearRange.start
        self.lowerBirthYear = dto.birthYearRange.end
        self.jobOccupations = dto.jobOccupations.map { $0.rawValue }
        self.allowSameCompany = dto.allowSameCompany
        
        switch dto.preferDistance {
        case .ONLY_MY_AREA:
            self.distanceType = .myArea
        case .INCLUDE_SURROUNDING_REGIONS:
            self.distanceType = .surroundRegion
        case .ANYWHERE:
            self.distanceType = .anywhere
        }
    }
    
    public static var mock: DreamPartnerInfo {
        .init(
            upperBirthYear: 4,
            lowerBirthYear: 4,
            jobOccupations: [],
            distanceType: .myArea,
            allowSameCompany: true
        )
    }
}

public struct ProfileWidget: Hashable {
    public let widgetType: WidgetType
    public let content: String
    
    static var mock: [ProfileWidget] {
        [
            .init(widgetType: .body, content: "GOOD BODY"),
            .init(widgetType: .smoking, content: "Heavy Smoker !!")
        ]
    }
    
    public init(
        widgetType: WidgetType,
        content: String
    ) {
        self.widgetType = widgetType
        self.content = content
    }
    
    public init(from dto: Components.Schemas.ProfileWidget) {
        self.widgetType = WidgetType(from: dto._type)
        self.content = dto.content
    }
}

public struct LocationModel {
    public let id: String
    public let name: String
    
    public static var mock: [LocationModel] {
        [
            .init(id: "1", name: "용인"),
            .init(id: "2", name: "성남"),
            .init(id: "3", name: "강남구"),
            .init(id: "4", name: "중구")
        ]
    }
}
