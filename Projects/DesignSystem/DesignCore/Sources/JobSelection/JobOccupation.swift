//
//  JobOccupation.swift
//  DesignCore
//
//  Created by 김지수 on 10/16/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public enum JobOccupation: CaseIterable {
    /// 경영관리
    case business
    /// 영업 마케팅
    case marketing
    /// 연구개발
    case research
    /// IT 정보통신
    case IT
    /// 금융 회계
    case financial
    /// 생산 제조
    case manufacture
    /// 교육 학술
    case education
    /// 법률 행정
    case law
    /// 경찰 소방 군인
    case policeFirefighterMilitary
    /// 의료 보건
    case medical
    /// 미디어 언론
    case mediaPress
    /// 예술 문화
    case artCulture
    /// 스포츠
    case sports
    /// 건설 토목
    case construction
    /// 운송 물류
    case transport
    /// 농림 어업
    case farming
    /// 서비스
    case service
    /// 기타
    case etc
}

extension JobOccupation {
    public var name: String {
        switch self {
        case .business: "경영·관리"
        case .marketing: "영업·마케팅"
        case .research: "연구·개발"
        case .IT: "IT·정보통신"
        case .financial: "금융·회계"
        case .manufacture: "생산·제조"
        case .education: "교육·학술"
        case .law: "법률·행정"
        case .policeFirefighterMilitary: "경찰·소방·군인"
        case .medical: "의료·보건"
        case .mediaPress: "미디어·언론"
        case .artCulture: "예술·문화"
        case .sports: "스포츠"
        case .construction: "건설·토목"
        case .transport: "운송·물류"
        case .farming: "농림·어업"
        case .service: "서비스"
        case .etc: "기타"
        }
    }
    
    public var icon: Image {
        switch self {
        case .business: DesignCore.Images.business.image
        case .marketing: DesignCore.Images.marketing.image
        case .research: DesignCore.Images.research.image
        case .IT: DesignCore.Images.it.image
        case .financial: DesignCore.Images.financial.image
        case .manufacture: DesignCore.Images.manufacture.image
        case .education: DesignCore.Images.education.image
        case .law: DesignCore.Images.law.image
        case .policeFirefighterMilitary: DesignCore.Images.military.image
        case .medical: DesignCore.Images.medical.image
        case .mediaPress: DesignCore.Images.media.image
        case .artCulture: DesignCore.Images.artist.image
        case .sports: DesignCore.Images.sports.image
        case .construction: DesignCore.Images.construction.image
        case .transport: DesignCore.Images.transport.image
        case .farming: DesignCore.Images.farming.image
        case .service: DesignCore.Images.service.image
        case .etc: DesignCore.Images.etc.image
        }
    }
}
