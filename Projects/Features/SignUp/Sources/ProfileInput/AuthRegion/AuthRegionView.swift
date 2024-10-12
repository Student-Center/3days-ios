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
import SignUpDomain

public struct AuthRegionView: View {
    
    @StateObject var container: MVIContainer<AuthRegionIntent.Intentable, AuthRegionModel.Stateful>
    
    private var intent: AuthRegionIntent.Intentable { container.intent }
    private var state: AuthRegionModel.Stateful { container.model }
    
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
                    ForEach(state.mainRegions, id: \.self) { region in
                        let isSelected = region == state.selectedMainRegion
                        regionLabel(
                            region: region,
                            isSelected: isSelected
                        )
                        .shadow(.default)
                        .onTapGesture {
                            intent.onTapMainRegion(region)
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
                    .shadow(.default)
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(
                        DesignCore.Colors.blue50
                    )
                    .padding(3)
                
                VStack(spacing: 0) {
                    HStack(spacing: 4) {
                        DesignCore.Images.locationMark.image
                        LeftAlignText(state.selectedMainRegion ?? "")
                            .typography(.medium_14)
                            .foregroundStyle(DesignCore.Colors.blue500)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 0)
                    
                    GeometryReader { geometry in
                        ZStack {
                            let tagModels = state.subRegions.map {
                                TagModel(id: $0.id, name: $0.subRegion)
                            }
                            let selectedTagModels = state.selectedSubRegions.map {
                                TagModel(id: $0.id, name: $0.subRegion)
                            }
                            TagListView(
                                tagModels: tagModels,
                                selectedTagModels: selectedTagModels,
                                onSelectedTag: { index in
                                    intent.onTapSubRegion(
                                        totalSubRegions: state.selectedSubRegions,
                                        selectedSubRegion: state.subRegions[index]
                                    )
                                }
                            )
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .id(selectedTagModels.map { $0.id }.joined())
                            .contentShape(Rectangle())
                            
                            VStack {
                                LinearGradient(
                                    colors: [DesignCore.Colors.blue50, .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 20)
                                .padding(.horizontal, 3)
                                .offset(y: -2)
                                
                                Spacer()
                                
                                LinearGradient(
                                    colors: [DesignCore.Colors.blue50, .clear],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                .frame(height: 20)
                                .padding(.horizontal, 3)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                        .frame(height: geometry.size.height)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
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
        .frame(width: 90, height: 42)
    }
}

#Preview {
    NavigationView {
        AuthRegionView()
    }
}
