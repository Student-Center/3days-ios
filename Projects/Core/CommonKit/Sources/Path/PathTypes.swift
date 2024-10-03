//
//  PathTypes.swift
//  CommonKit
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

public enum PathType: Hashable {
    case designPreview
    case main
    case signUp(SignUpSubViewType)
    
    #if STAGING || DEBUG
    public static var debugPreviewTypes: [PathType] = [
        .designPreview,
        .main,
        .signUp(.authPhoneInput)
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
            case .authName: return "이름 입력"
            }
        }
    }
}

public enum SignUpSubViewType: Hashable {
    case authPhoneInput
    case authPhoneVerify
    case authAgreement
    
    case authGreeting
    case authProfileGender
    case authProfileAge
    case authName
}
