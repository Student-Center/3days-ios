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
    
    func requestDeleteProfileWidget(
        widgetType: Components.Schemas.ProfileWidgetType
    ) async throws
    
    func requestPutUserInfo(userInfo: UserInfo) async throws
    
    func requestPutPartnerInfo(userInfo: UserInfo) async throws
    
    func requestUploadImage(image: Data) async throws
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
    
    public func requestDeleteProfileWidget(
        widgetType: Components.Schemas.ProfileWidgetType
    ) async throws {
        let response = try await client.deleteProfileWidget(
            .init(
                path: .init(_type: widgetType)
            )
        )
        _ = try response.noContent
    }
    
    public func requestPutUserInfo(userInfo: UserInfo) async throws {
        guard let jobOccupation = userInfo.profile.jobOccupationDTO else {
            return
        }
        let result = try await client.updateMyUserInfo(
            .init(
                body: .json(
                    .init(
                        name: userInfo.name,
                        jobOccupation: jobOccupation,
                        companyId: userInfo.profile.companyId,
                        allowSameCompany: userInfo.dreamPartner.allowSameCompany,
                        locationIds: userInfo.profile.locations.map { $0.id }
                    )
                )
            )
        )
        _ = try result.ok
    }
    
    public func requestPutPartnerInfo(userInfo: UserInfo) async throws {
        let dreamPartner = userInfo.dreamPartner
        let jobOccupations = dreamPartner.jobOccupations
            .compactMap { Components.Schemas.JobOccupation(rawValue: $0) }
        
        let result = try await client.updateMyDesiredPartner(
            .init(
                body: .json(
                    .init(
                        birthYearRange: .init(
                            start: dreamPartner.lowerBirthYear,
                            end: dreamPartner.upperBirthYear
                        ),
                        jobOccupations: jobOccupations,
                        preferDistance: dreamPartner.distanceType.toDto
                    )
                )
            )
        )
        _ = try result.ok
        return
    }
    
    public func requestUploadImage(image: Data) async throws {
        // url 받기
        let uploadUrlInfo = try await requestPresignedUrl()
        
        // url로 업로드
        try await requestUploadImage(image: image, url: uploadUrlInfo.url)
        
        // 콜백 전달
        try await requestCompleteCallback(imageId: uploadUrlInfo.imageId)
    }
    
    private func requestPresignedUrl() async throws -> Components.Schemas.GetProfileImageUploadUrlResponse {
        let result = try await client.getProfileImageUploadUrl(query: .init(_extension: .PNG))
        return try result.ok.body.json
    }
    
    private func requestUploadImage(image: Data, url: String) async throws {
        debugPrint("✅ [Upload Image Start]")
        guard let url = URL(string: url) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("image/png", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(
            "Bearer \(TokenManager.accessToken ?? "")",
            forHTTPHeaderField: "Authorization"
        )

        debugPrint("✅ [Upload Image Url] : \(url)")
        debugPrint("✅ [Upload Image] : \(image)")
        debugPrint("✅ [Upload Header] : \(urlRequest.allHTTPHeaderFields)")
        let (_, urlResponse) = try await URLSession.shared.upload(for: urlRequest, from: image)
        
        debugPrint("✅ [Response] : \(urlResponse)")
        guard let response = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard 200 <= response.statusCode && response.statusCode <= 299 else {
            throw URLError(.badServerResponse)
        }
        return
    }
    
    private func requestCompleteCallback(imageId: String) async throws {
        let result = try await client.completeProfileImageUpload(body: .json(.init(imageId: imageId)))
        _ = try result.ok
    }
}
