//
//  ProfilePannelView.swift
//  Home
//
//  Created by 김지수 on 11/3/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import UIKit
import CoreKit
import DesignCore
import CommonKit
import Model

public struct ProfilePannelView: View {
    
    @StateObject var container: MVIContainer<ProfilePannelIntent.Intentable, ProfilePannelModel.Stateful>
    
    private var intent: ProfilePannelIntent.Intentable { container.intent }
    private var state: ProfilePannelModel.Stateful { container.model }
    
    public init(name: String, profile: UserInfoProfile) {
        let model = ProfilePannelModel()
        let intent = ProfilePannelIntent(
            model: model,
            input: .init(
                name: name,
                profile: profile
            )
        )
        let container = MVIContainer(
            intent: intent as ProfilePannelIntent.Intentable,
            model: model as ProfilePannelModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    @ViewBuilder
    var circleDot: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: 0xD2D2D2), lineWidth: 1)
                .fill(Color(hex: 0xEBEBEB))
                .frame(width: 12, height: 12)
        }
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 6) {
                HStack {
                    Spacer()
                    ZStack {
                        DesignCore.Images.profileDefault.image
                            .cornerRadius(20, corners: .allCorners)
                        DesignCore.Images.profileBorder.image
                    }
                    .frame(width: 102, height: 102)
                    Spacer()
                }
                .shadow(.default)
                
                VStack(spacing: 4) {
                    Text(state.name ?? "")
                        .pretendard(weight: ._600, size: 28)
                        .foregroundStyle(Color(hex: 0x1F1F1F))
                    
                    Text("\(state.profile?.birthYear.toString() ?? "")년생")
                        .pretendard(weight: ._500, size: 14)
                        .foregroundStyle(Color(hex: 0xA0A0A0))
                }
                .padding(.bottom, 16)
                
                innerRoundBoxView(
                    fillColor: DesignCore.Colors.green50,
                    strokeColor: Color(hex: 0xE6EFDF)
                ) {
                    horizonIconKeyValueView(
                        icon: DesignCore.Images.businessFill.image,
                        key: "직군",
                        value: state.profile?.jobOccupation ?? "-",
                        textColor: Color(hex: 0x5B6654)
                    )
                }
                
                innerRoundBoxView(
                    fillColor: DesignCore.Colors.pink50,
                    strokeColor: Color(hex: 0xEFDFE5)
                ) {
                    horizonIconKeyValueView(
                        icon: DesignCore.Images.buildingFill.image,
                        key: "직장",
                        value: state.profile?.companyName ?? "",
                        textColor: Color(hex: 0x846470)
                    )
                }
                
                if let profile = state.profile {
                    innerRoundBoxView(
                        fillColor: DesignCore.Colors.blue50,
                        strokeColor: Color(hex: 0xDFE8EF)
                    ) {
                        VStack {
                            horizonIconKeyValueView(
                                icon: DesignCore.Images.locationFill.image,
                                key: "활동 지역",
                                value: nil,
                                textColor: Color(hex: 0x606D8F)
                            )
                            let tagModels: [TagModel] = profile.locations
                                .map {
                                    .init(
                                        id: $0.id,
                                        name: $0.name
                                    )
                                }
                            
                            TagListView(
                                tagModels: tagModels,
                                selectedTagModels: []
                            ) { _ in }
                                .frame(
                                    height: TagListCollectionView.calculateHeight(
                                        tags: tagModels,
                                        deviceWidth: Device.width - (76 + 36)
                                    )
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 80)
        }
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: 51)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.white)
                    
                    VStack {
                        HStack {
                            circleDot
                            Spacer()
                            circleDot
                        }
                        Spacer()
                        HStack {
                            circleDot
                            Spacer()
                            circleDot
                        }
                    }
                    .padding(.all, 16)
                }
            }
            .shadow(.default)
        }
        .padding(.vertical, 30)
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
    }
    
    @ViewBuilder
    func horizonIconKeyValueView(
        icon: Image,
        key: String,
        value: String?,
        textColor: Color
    ) -> some View {
        HStack(spacing: 6) {
            icon
                .resizable()
                .frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
            Text(key)
                .typography(.medium_14)
            Spacer()
            if let value {
                Text(value)
                    .typography(.medium_16)
                    .multilineTextAlignment(.trailing)
            }
        }
        .foregroundStyle(textColor)
    }
    
    @ViewBuilder
    func innerRoundBoxView(
        fillColor: Color,
        strokeColor: Color,
        contentView: @escaping () -> some View
    ) -> some View {
        VStack {
            contentView()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .stroke(strokeColor, lineWidth: 1)
                .fill(fillColor)
        }
    }
}

#Preview {
    NavigationView {
        ProfilePannelView(
            name: "김삼일",
            profile: .mock
        )
    }
}
