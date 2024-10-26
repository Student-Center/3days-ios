//
//  SignUpFormDomain.swift
//  SignUpDomain
//
//  Created by 김지수 on 10/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated

public struct SignUpFormDomain {
    public let registerToken: String
    public var name: String?
    public var phone: String?
    public var profile: SignUpProfileDomain?
    public var dreamPartner: SignUpDreamPartnerDomain?
    
    public var toDomain: Components.Schemas.RegisterUserRequest? {
        guard let name,
              let phone,
              let profile = profile?.toDto,
              let dreamPartner = dreamPartner?.toDto else { return nil }
        return .init(
            name: name,
            phoneNumber: phone,
            profile: profile,
            desiredPartner: dreamPartner
        )
    }
}

public struct SignUpProfileDomain {
    public let gender: GenderType?
    public let birthYear: Int?
    public let companyId: String?
    public let jobOccupation: String?
    public let locationIds: [String]
    
    var toDto: Components.Schemas.UserProfile? {
        guard let gender,
              let birthYear,
              let jobOccupation,
              let jobOccupationRequest = Components.Schemas.JobOccupation(rawValue: jobOccupation) else { return nil }
        return .init(
            gender: gender.toDto,
            birthYear: birthYear,
            companyId: companyId ?? "",
            jobOccupation: jobOccupationRequest,
            locationIds: locationIds
        )
    }
}

public struct SignUpDreamPartnerDomain {
    public var lowerBirthYearGap: Int?
    public var upperBirthYearGap: Int?
    public var jobOccupations: [String]
    public var distanceType: DreamPartnerDistanceType?
    
    var toDto: Components.Schemas.UserDesiredPartner? {
        guard let distanceType else {
            return nil
        }
        let jobOccupations = jobOccupations.compactMap {
            Components.Schemas.JobOccupation(rawValue: $0)
        }
        return .init(
            birthYearRange: .init(
                start: lowerBirthYearGap,
                end: upperBirthYearGap
            ),
            jobOccupations: jobOccupations,
            preferDistance: distanceType.toDto
        )
    }
}

public enum DreamPartnerDistanceType: CaseIterable {
    case myArea
    case surroundRegion
    case anywhere
    
    public var description: String {
        switch self {
        case .myArea: "내 활동 지역에서만 받는 걸 선호해요"
        case .surroundRegion: "내 활동 지역을 포함한 시,도까지 괜찮아요"
        case .anywhere: "어디든 괜찮아요"
        }
    }
    
    var toDto: Components.Schemas.PreferDistance {
        switch self {
        case .myArea: .ONLY_MY_AREA
        case .surroundRegion: .INCLUDE_SURROUNDING_REGIONS
        case .anywhere: .ANYWHERE
        }
    }
}

public enum GenderType: CaseIterable {
    case male
    case female
    
    var toDto: Components.Schemas.Gender {
        switch self {
        case .male: .MALE
        case .female: .FEMALE
        }
    }
}
