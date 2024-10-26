//
//  PathTypes.swift
//  CommonKit
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import Model

public enum PathType: Hashable {
    case designPreview
    case main
    case signUp(SignUpSubViewType)
    
    #if STAGING || DEBUG
    public static var debugPreviewTypes: [PathType] = [
        .designPreview,
        .main,
        .signUp(.authPhoneInput),
        .signUp(
            .authPhoneVerify(
                SMSSendResponse(
                    userType: .NEW,
                    authCodeId: "tempCode",
                    phoneNumber: "010-1234-5678"
                )
            )
        ),
        .signUp(.authAgreement),
        .signUp(.authGreeting),
        .signUp(.authProfileGender),
        .signUp(.authProfileAge),
        .signUp(.authCompany),
        .signUp(.authJobOccupation),
        .signUp(.authName),
        .signUp(.authRegion),
        .signUp(.authPhoneInput),
        
        .signUp(.dreamPartnerAgeRange)
    ]
    #endif
    
    public var name: String {
        switch self {
        case .designPreview: return "Design Preview"
        case .main: return "메인"
        case .signUp(let subType):
            switch subType {
            case .authPhoneInput: return "전화번호 입력"
            case .authPhoneVerify: return "전화번호 인증"
            case .authAgreement: return "이용 약관"
            
            case .authGreeting: return "가입 후 환영"
            case .authProfileGender: return "성별 입력"
            case .authProfileAge: return "나이 입력"
            case .authCompany: return "내 직장 입력"
            case .authJobOccupation: return "내 직업 직군"
            case .authRegion: return "내 지역, 선호 지역 입력"
            case .authName: return "이름 입력"
                
            case .dreamPartnerAgeRange: return "이상형 나이대"
            case .dreamPartnerJobOccupation: return "이상형 직업"
            case .dreamPartnerDistance: return "이상형과의 거리"
            }
        }
    }
}

public enum SignUpSubViewType: Hashable {
    case authPhoneInput
    case authPhoneVerify(SMSSendResponse)
    case authAgreement
    
    case authGreeting
    case authProfileGender
    case authProfileAge
    case authCompany
    case authJobOccupation
    case authRegion
    case authName
    
    case dreamPartnerAgeRange
    case dreamPartnerJobOccupation
    case dreamPartnerDistance
    
    public static func == (lhs: SignUpSubViewType, rhs: SignUpSubViewType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .authPhoneInput:
            hasher.combine(0)
        case .authPhoneVerify:
            hasher.combine(1)
        case .authAgreement:
            hasher.combine(2)
        case .authGreeting:
            hasher.combine(3)
        case .authProfileGender:
            hasher.combine(4)
        case .authProfileAge:
            hasher.combine(5)
        case .authCompany:
            hasher.combine(6)
        case .authJobOccupation:
            hasher.combine(7)
        case .authRegion:
            hasher.combine(8)
        case .authName:
            hasher.combine(9)
            
        case .dreamPartnerAgeRange:
            hasher.combine(10)
        case .dreamPartnerJobOccupation:
            hasher.combine(11)
        case .dreamPartnerDistance:
            hasher.combine(12)
        }
    }
}
