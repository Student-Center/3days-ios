//
//  EditProfileRegionView.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

public struct EditProfileRegionView: View {
    
    @StateObject var container: MVIContainer<EditProfileRegionIntent.Intentable, EditProfileRegionModel.Stateful>
    
    private var intent: EditProfileRegionIntent.Intentable { container.intent }
    private var state: EditProfileRegionModel.Stateful { container.model }
    
    public init(userInfo: UserInfo) {
        let model = EditProfileRegionModel()
        let intent = EditProfileRegionIntent(
            model: model,
            input: .init(userInfo: userInfo)
        )
        let container = MVIContainer(
            intent: intent as EditProfileRegionIntent.Intentable,
            model: model as EditProfileRegionModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if let userInfo = state.userInfo {
                    HStack {
                        Text("🧭 내 활동 지역")
                            .typography(.regular_12)
                        Text(userInfo.profile.locations
                            .map { $0.name }
                            .joined(separator: ", ")
                        )
                        .pretendard(
                            weight: ._600,
                            size: 12
                        )
                    }
                    .foregroundStyle(DesignCore.Colors.grey400)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(DesignCore.Colors.yellow50)
                            .stroke(
                                Color(hex: 0xEDE9C1),
                                lineWidth: 1
                            )
                    )
                    .padding(.vertical, 20)
                }
                ScrollViewReader { reader in
                    HStack(alignment: .center) {
                        VStack(alignment: .center) {
                            Spacer()
                            Text("내 지역")
                                .typography(.regular_14)
                                .foregroundStyle(DesignCore.Colors.blue500)
                                .padding(.bottom, 10)
                        }
                        .frame(width: 46, height: 34)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0 ..< state.selectedSubRegions.count, id: \.self) { index in
                                    let subRegion = state.selectedSubRegions[index]
                                    selectedRegionSingleChip(text: subRegion.subRegion)
                                        .id(subRegion.id)
                                        .onTapGesture {
                                            intent.onTapSubRegion(
                                                totalSubRegions: state.selectedSubRegions,
                                                selectedSubRegion: subRegion
                                            )
                                        }
                                        .onAppear {
                                            if index == state.selectedSubRegions.count - 1 {
                                                withAnimation {
                                                    reader.scrollTo(subRegion.id)
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    
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
            .padding(.horizontal, 26)
            
            CTABottomButton(
                title: "다음",
                isActive: state.isValidated
            ) {
                intent.onTapNextButton(state: state)
            }
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("활동 지역 수정")
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
    
    @ViewBuilder
    func selectedRegionSingleChip(text: String) -> some View {
        HStack(spacing: 4) {
            Text(text)
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 10, height: 10)
        }
        .typography(.medium_14)
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .frame(height: 34)
        .background {
            Capsule()
                .inset(by: 1)
                .stroke(
                    .white,
                    lineWidth: 4
                )
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: 0x93CAF8),
                            Color(hex: 0x76B6EB)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        
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
        EditProfileRegionView(userInfo: .mock)
    }
}
