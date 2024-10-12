//
//  RegionDomain.swift
//  SignUpDomain
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated

public struct RegionDomain {
    public let id: String
    public let mainRegion: String
    public let subRegion: String
    
    public init(
        id: String,
        mainRegion: String,
        subRegion: String
    ) {
        self.id = id
        self.mainRegion = mainRegion
        self.subRegion = subRegion
    }
    
    public init(dto: Components.Schemas.Location) {
        self.id = dto.id
        self.mainRegion = dto.region
        self.subRegion = dto.subRegion
    }
}
