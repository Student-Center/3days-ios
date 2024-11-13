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
}
