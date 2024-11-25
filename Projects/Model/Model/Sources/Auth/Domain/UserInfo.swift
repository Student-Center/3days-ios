//
//  UserInfo.swift
//  Model
//
//  Created by 김지수 on 10/27/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated

public struct UserInfo: Equatable, Identifiable, Hashable {
    public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        if lhs.id != rhs.id { return false }
        if lhs.name != rhs.name { return false }
        if lhs.phone != rhs.phone { return false }
        if lhs.profile != rhs.profile { return false }
        if lhs.dreamPartner != rhs.dreamPartner { return false }
        if lhs.profileWidgets != rhs.profileWidgets { return false }
        return true
    }
    
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

public struct UserInfoProfile: Hashable, Identifiable, Equatable {
    
    public static func == (lhs: UserInfoProfile, rhs: UserInfoProfile) -> Bool {
        if lhs.id != rhs.id { return false }
        if lhs.gender != rhs.gender { return false }
        if lhs.birthYear != rhs.birthYear { return false }
        if lhs.companyId != rhs.companyId { return false }
        if lhs._companyName != rhs._companyName { return false }
        if lhs.jobOccupation != rhs.jobOccupation { return false }
        if lhs.jobOccupationRawValue != rhs.jobOccupationRawValue { return false }
        if lhs.locations != rhs.locations { return false }
        return true
    }
    
    public let id: String = UUID().uuidString
    
    public let gender: GenderType
    public let birthYear: Int
    public var companyId: String?
    private var _companyName: String?
    public let jobOccupation: String
    public var jobOccupationRawValue: String
    public var locations: [LocationModel]
    
    public var companyName: String {
        set {
            _companyName = newValue
        }
        get {
            return _companyName ?? "새회사"
        }
    }
    
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
        self._companyName = companyName
        self.jobOccupation = jobOccupation
        self.jobOccupationRawValue = jobOccupationRawValue
        self.locations = locations
    }
    
    public init(from dto: Components.Schemas.UserProfileDisplayInfo) {
        self.gender = dto.gender == .MALE ? .male : .female
        self.birthYear = dto.birthYear
        self.companyId = dto.company?.id
        self._companyName = dto.company?.display
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

public struct DreamPartnerInfo: Equatable, Hashable {
    public static func == (lhs: DreamPartnerInfo, rhs: DreamPartnerInfo) -> Bool {
        if lhs.upperBirthYear != rhs.upperBirthYear { return false }
        if lhs.lowerBirthYear != rhs.lowerBirthYear { return false }
        if lhs.jobOccupations != rhs.jobOccupations { return false }
        if lhs.distanceType != rhs.distanceType { return false }
        if lhs.allowSameCompany != rhs.allowSameCompany { return false }
        return true
    }
    public var upperBirthYear: Int?
    public var lowerBirthYear: Int?
    public let jobOccupations: [String]
    public let distanceType: DreamPartnerDistanceType
    public var allowSameCompany: Bool?
    
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
            jobOccupations: [
                "MEDIA_ENTERTAINMENT",
                "HEALTHCARE_MEDICAL",
                "SPORTS",
                "ARTS_DESIGN",
                "MANUFACTURING_PRODUCTION"
            ],
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

public struct LocationModel: Hashable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    public static var mock: [LocationModel] {
        [
            .init(id: "1", name: "용인"),
            .init(id: "2", name: "성남"),
            .init(id: "3", name: "강남구"),
            .init(id: "4", name: "중구")
        ]
    }
}
