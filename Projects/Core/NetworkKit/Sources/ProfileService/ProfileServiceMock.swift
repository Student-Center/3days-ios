//
//  ProfileServiceMock.swift
//  NetworkKit
//
//  Created by 김지수 on 11/15/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import OpenapiGenerated
import CoreKit

public final class ProfileServiceMock: ProfileServiceProtocol {
    public init() {}
    
    public func requestPutProfileWidget(
        widgetType: Components.Schemas.ProfileWidgetType,
        content: String
    ) async throws {
        print("✅ [ProfileServiceMock] requestPutProfileWidget 성공!")
        return
    }
    
    public func requestDeleteProfileWidget(
        widgetType: Components.Schemas.ProfileWidgetType
    ) async throws {
        print("✅ [ProfileServiceMock] requestDeleteProfileWidget 성공!")
        return
    }
}
