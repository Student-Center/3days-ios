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
        case .userInfo: "유저 정보(TEMP)"
        case .userProfile: "프로필 정보(TEMP)"
        case .dreamPartnerInfo: "이상형 정보(TEMP)"
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
                    value: "홍길동"
                ),
                TableInfoModel(
                    title: "휴대폰 번호",
                    value: "010-1234-1234"
                )
            ]
        case .userProfile:
            [
                TableInfoModel(
                    title: "출생년도",
                    value: "1996"
                ),
                TableInfoModel(
                    title: "회사 ID",
                    value: UUID().uuidString
                ),
                TableInfoModel(
                    title: "성별",
                    value: "MALE"
                ),
                TableInfoModel(
                    title: "직군정보",
                    value: UUID().uuidString
                ),
                TableInfoModel(
                    title: "활동지역 ID",
                    value: [UUID(), UUID(), UUID()]
                        .map { $0.uuidString }
                        .joined(separator: "\n")
                )
            ]
        case .dreamPartnerInfo:
            []
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
