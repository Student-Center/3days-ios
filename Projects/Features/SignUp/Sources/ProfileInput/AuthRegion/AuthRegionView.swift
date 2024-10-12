//
//  AuthRegionView.swift
//  SignUp
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthRegionView: View {
    
    @StateObject var container: MVIContainer<AuthRegionIntent.Intentable, AuthRegionModel.Stateful>
    
    private var intent: AuthRegionIntent.Intentable { container.intent }
    private var state: AuthRegionModel.Stateful { container.model }
    
    @State var regionData = [
        "강원",
        "경기",
        "경남",
        "경북",
        "광주",
        "대구",
        "대전",
        "부산",
        "서울",
        "세종",
        "울산",
        "인천",
        "전남",
        "전북",
        "제주",
        "충남",
        "충북"
      ]
    @State var selectedRegion = "경기"
    
    var subRegionData = [
        "중원구",
        "노원구",
        "강남구",
        "서초구",
        "미추홀구",
        "중구",
        "곡반정동",
        "우리집",
        "긴구구구구",
        "두글",
        "우옹"
    ]
    
    @State var selectedSubRegion = ["중원구", "노원구"]
    
    public init() {
        let model = AuthRegionModel()
        let intent = AuthRegionIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as AuthRegionIntent.Intentable,
            model: model as AuthRegionModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            ProfileInputTemplatedView(
                currentPage: 5,
                maxPage: 5,
                subMessage: "설레는 만남이 다가오고 있어요.",
                mainMessage: "당신의 활동 지역은 어디인가요?"
            ) {
                VStack {
                    LeftAlignText("내 지역")
                        .typography(.regular_14)
                        .foregroundStyle(DesignCore.Colors.blue500)
                        .padding(.bottom, 10)
                    
                    VStack {
                        ZStack {
                            leftRegionScrollView
                            rightSubRegionSectionView
                        }
                        Spacer()
                    }
                    .padding(.bottom, 90)
                }
            }
            
            CTABottomButton(
                title: "다음"
            ) {
                
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.keyboard)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
    
    @ViewBuilder
    var leftRegionScrollView: some View {
        HStack {
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(regionData, id: \.self) { region in
                        let isSelected = region == selectedRegion
                        regionLabel(
                            region: region,
                            isSelected: isSelected
                        )
                        .onTapGesture {
                            selectedRegion = region
                        }
                    }
                }
            }
            .scrollIndicators(.never)
            .padding(.vertical, 12)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var rightSubRegionSectionView: some View {
        HStack {
            Spacer()
                .frame(width: 60)
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(
                        DesignCore.Colors.blue50
                    )
                    .padding(3)
                
                VStack {
                    HStack(spacing: 4) {
                        DesignCore.Images.locationMark.image
                        LeftAlignText(selectedRegion)
                            .typography(.medium_14)
                            .foregroundStyle(DesignCore.Colors.blue500)
                    }
                    .padding(.horizontal, 20)
                    
                    GeometryReader { geometry in
                        ScrollView {
                            CustomTagListView(
                                capsuleViews,
                                horizontalSpace: 6,
                                verticalSpace: 6
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.vertical, 20)
            }
        }
    }
    
    var capsuleViews: [CustomTagSingleView<SubRegionCapsuleView>] {
        subRegionData.map { data in
            let index = selectedSubRegion.firstIndex { $0 == data }
            return CustomTagSingleView {
                SubRegionCapsuleView(text: data, isSelected: index != nil)
            }
        }
    }
    
    struct SubRegionCapsuleView: View {
        
        let text: String
        let isSelected: Bool
        
        var body: some View {
            ZStack {
                Text(text)
                    .typography(.medium_14)
                    .foregroundColor(isSelected ? .white : DesignCore.Colors.blue500)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background {
                        Capsule()
                            .inset(by: 1)
                            .stroke(
                                isSelected ? .white : Color(hex: 0xDFE8EF),
                                lineWidth: isSelected ? 3 : 1
                            )
                            .fill(
                                isSelected ?
                                LinearGradient(
                                    colors: [
                                        Color(hex: 0x93CAF8),
                                        Color(hex: 0x76B6EB)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )  : LinearGradient(
                                    colors: [.white],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
            }
        }
    }
    
    @ViewBuilder
    func regionLabel(region: String, isSelected: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(isSelected ? DesignCore.Colors.blue500 : Color(hex: 0xD3D3D3))
            LeftAlignText(region)
                .foregroundStyle(.white)
                .typography(.semibold_14)
                .padding(.leading, 14)
        }
        .shadow(.default)
        .frame(width: 90, height: 42)
    }
}

#Preview {
    NavigationView {
        AuthRegionView()
    }
}
