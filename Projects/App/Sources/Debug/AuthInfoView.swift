//
//  AuthInfoView.swift
//  three-days-dev
//
//  Created by 김지수 on 10/27/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore
import CoreKit
import CommonKit

#if DEBUG || STAGING
struct TableInfoModel: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

enum Sections: CaseIterable {
    case authInfo
    case userInfo
    case userProfile
    case dreamPartnerInfo
    
    var sectionTitle: String {
        switch self {
        case .authInfo: "토큰 정보"
        case .userInfo: "유저 정보"
        case .userProfile: "프로필 정보"
        case .dreamPartnerInfo: "이상형 정보"
        }
    }
    
    var dataSources: [TableInfoModel] {
        switch self {
        case .authInfo:
            [
                TableInfoModel(
                    title: "accessToken",
                    value: TokenManager.accessToken ?? "null"
                ),
                TableInfoModel(
                    title: "refreshToken",
                    value: TokenManager.refreshToken ?? "null"
                ),
                TableInfoModel(
                    title: "registerToken",
                    value: TokenManager.registerToken ?? "null"
                )
            ]
        case .userInfo:
            [
                TableInfoModel(
                    title: "ID",
                    value: UUID().uuidString
                ),
                TableInfoModel(
                    title: "이름",
                    value: AppCoordinator.shared.userInfo?.name ?? "null"
                ),
                TableInfoModel(
                    title: "휴대폰 번호",
                    value: AppCoordinator.shared.userInfo?.phone ?? "null"
                )
            ]
        case .userProfile:
            [
                TableInfoModel(
                    title: "출생년도",
                    value: AppCoordinator.shared.userInfo?.profile.birthYear == nil ? "null" : String((AppCoordinator.shared.userInfo?.profile.birthYear)!)
                ),
                TableInfoModel(
                    title: "회사 ID",
                    value: AppCoordinator.shared.userInfo?.profile.companyId ?? "null"
                ),
                TableInfoModel(
                    title: "성별",
                    value: AppCoordinator.shared.userInfo?.profile.gender.rawValue ?? "null"
                ),
                TableInfoModel(
                    title: "직군정보",
                    value: AppCoordinator.shared.userInfo?.profile.jobOccupation ?? "null"
                ),
                TableInfoModel(
                    title: "활동지역 ID",
                    value: AppCoordinator.shared.userInfo?.profile.locations != nil ? AppCoordinator.shared.userInfo!.profile.locations
                        .compactMap { "\($0.name) / \($0.id)" }
                        .joined(separator: "\n") : "null"
                )
            ]
        case .dreamPartnerInfo:
            [
                TableInfoModel(
                    title: "출생년도 범위",
                    value: "\(AppCoordinator.shared.userInfo?.dreamPartner.lowerBirthYear ?? 0) ~ \(AppCoordinator.shared.userInfo?.dreamPartner.upperBirthYear ?? 0)"
                ),
                TableInfoModel(
                    title: "같은 회사 소개 여부",
                    value: AppCoordinator.shared.userInfo?.dreamPartner.allowSameCompany == nil ? "null" : String((AppCoordinator.shared.userInfo?.dreamPartner.allowSameCompany)!)
                ),
                TableInfoModel(
                    title: "거리",
                    value: AppCoordinator.shared.userInfo?.dreamPartner.distanceType.description ?? "null"
                ),
                TableInfoModel(
                    title: "직군정보",
                    value: AppCoordinator.shared.userInfo?.dreamPartner.jobOccupations != nil ? AppCoordinator.shared.userInfo!.dreamPartner.jobOccupations
                        .compactMap { $0 }
                        .joined(separator: "\n") : "null"
                )
            ]
        }
    }
}

struct AuthDebugInfoView: View {
    @State private var showingAlert = false
    @State private var copiedText = ""
    
    var body: some View {
        List {
            ForEach(Sections.allCases, id: \.self) { section in
                Section(header: Text(section.sectionTitle)) {
                    ForEach(section.dataSources) { info in
                        Button(action: {
                            copyToClipboard(info.value)
                            copiedText = info.title
                            showingAlert = true
                        }) {
                            VStack(alignment: .leading) {
                                Text(info.title)
                                    .pretendard(
                                        weight: ._600,
                                        size: 16
                                    )
                                    .foregroundStyle(.black)
                                Text(info.value)
                                    .pretendard(
                                        weight: ._400,
                                        size: 14
                                    )
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("복사 완료"),
                message: Text("[\(copiedText)] 정보가 클립보드에 복사되었습니다."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    
    // 클립보드에 복사하는 함수
    func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

#Preview {
    AuthDebugInfoView()
}

#endif
