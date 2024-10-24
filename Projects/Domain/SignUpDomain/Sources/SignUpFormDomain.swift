//
//  SignUpFormDomain.swift
//  SignUpDomain
//
//  Created by 김지수 on 10/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

struct SignUpFormDomain {
    let registerToken: String
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
}
