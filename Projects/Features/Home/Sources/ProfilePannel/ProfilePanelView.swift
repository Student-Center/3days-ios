//
//  ProfilePanelView.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import Model
import DesignCore
import CommonKit
import Nuke
import NetworkKit

struct ProfilePannelView: View {
    
    let name: String
    let profile: UserInfoProfile
    
    @State var isShowPhotoSheet: Bool = false
    @State var isShowPhotoPicker: Bool = false
    @State var isShowPhotoPreview: Bool = false
    @State var selectedImage: UIImage?
    
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
                    ZStack(alignment: .topTrailing) {
                        DesignCore.Images.profileDefault.image
                            .cornerRadius(20, corners: .allCorners)
                        if profile.profileImageUrl == nil {
                            DesignCore.Images.profileBorder.image
                        }
                        DesignCore.Images.cameraCircleFill.image
                            .resizable()
                            .frame(width: 36, height: 36)
                            .offset(x: 6, y: -6)
                            .onTapGesture {
                                isShowPhotoSheet = true
                            }
                            .confirmationDialog(
                                "프로필 사진 설정",
                                isPresented: $isShowPhotoSheet,
                                actions: {
                                    Button("앨범에서 사진 선택") {
                                        isShowPhotoPicker = true
                                    }
                                    Button("기본 이미지 적용") {
                                        // default image
                                    }
                                    Button("취소", role: .cancel) {}
                                },
                                message: {
                                    Text("프로필 사진 설정")
                                }
                            )
                            .photoPicker(
                                isPresented: $isShowPhotoPicker
                            ) { images in
                                selectedImage = images.first
                                isShowPhotoPreview = true
                            }
                            .navigationDestination(isPresented: $isShowPhotoPreview) {
                                PhotoPreviewView(
                                    image: selectedImage,
                                    isPresented: .constant(true),
                                    showButton: true,
                                    navigationTitle: "내 프로필 설정",
                                    buttonTitle: "프로필 사진으로 등록하기",
                                    backHandler: {
                                        isShowPhotoPreview = false
                                    },
                                    buttonHandler: { imageData in
                                        do {
                                            if let imageData {
                                                try await ProfileService.shared.requestUploadImage(image: imageData)
                                            }
                                            await MainActor.run {
                                                isShowPhotoPreview = false
                                            }
                                        } catch {
                                            print(error)
                                            ToastHelper.showErrorMessage(
                                                "프로필 사진 업로드에 실패하였습니다."
                                            )
                                        }
                                    }
                                )
                            }
                    }
                    .frame(width: 102, height: 102)
                    Spacer()
                }
                .shadow(.default)
                
                VStack(spacing: 4) {
                    Text(name)
                        .pretendard(weight: ._600, size: 28)
                        .foregroundStyle(Color(hex: 0x1F1F1F))
                    
                    Text("\(profile.birthYear.toString())년생")
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
                        value: profile.jobOccupation,
                        textColor: Color(hex: 0x5B6654),
                        showEditIcon: true
                    ) {
                        guard let userInfo = AppCoordinator.shared.userInfo else { return }
                        onTapEditIcon(type: .jobOccupation(userInfo))
                    }
                }
                
                innerRoundBoxView(
                    fillColor: DesignCore.Colors.pink50,
                    strokeColor: Color(hex: 0xEFDFE5)
                ) {
                    horizonIconKeyValueView(
                        icon: DesignCore.Images.buildingFill.image,
                        key: "직장",
                        value: profile.companyName,
                        textColor: Color(hex: 0x846470),
                        showEditIcon: true
                    ) {
                        guard let userInfo = AppCoordinator.shared.userInfo else { return }
                        onTapEditIcon(type: .company(userInfo))
                    }
                }
                
                innerRoundBoxView(
                    fillColor: DesignCore.Colors.blue50,
                    strokeColor: Color(hex: 0xDFE8EF)
                ) {
                    VStack {
                        horizonIconKeyValueView(
                            icon: DesignCore.Images.locationFill.image,
                            key: "활동 지역",
                            value: nil,
                            textColor: Color(hex: 0x606D8F),
                            showEditIcon: true
                        ) {
                            guard let userInfo = AppCoordinator.shared.userInfo else { return }
                            onTapEditIcon(type: .region(userInfo))
                        }
                        
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
    }
    
    @ViewBuilder
    func horizonIconKeyValueView(
        icon: Image,
        key: String,
        value: String?,
        textColor: Color,
        showEditIcon: Bool,
        editHandler: (() -> Void)? = nil
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
            if showEditIcon {
                DesignCore.Images.pencil1.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .onTapGesture {
                        editHandler?()
                    }
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
    
    func onTapEditIcon(type: EditProfileViewType) {
        Task {
            await MainActor.run {
                AppCoordinator.shared.push(.editProfile(type))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(userInfo: .mock)
    }
}
