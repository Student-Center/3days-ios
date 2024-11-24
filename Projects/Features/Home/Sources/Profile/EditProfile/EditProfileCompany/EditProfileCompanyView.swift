//
//  EditProfileCompanyView.swift
//  SignUp
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import SearchCompany
import Model

public struct EditProfileCompanyView: View {
    
    @StateObject var container: MVIContainer<EditProfileCompanyIntent.Intentable, EditProfileCompanyModel.Stateful>
    
    private var intent: EditProfileCompanyIntent.Intentable { container.intent }
    private var state: EditProfileCompanyModel.Stateful { container.model }
    
    @FocusState var showDropDown: Bool
    var bottomSpacingHeight: CGFloat {
        return showDropDown ? Device.height * 0.7 : 0
    }
    
    public init(userInfo: UserInfo) {
        let searchCompanyState = SearchCompanyModel()
        let searchCompanyIntent = SearchCompanyIntent(
            model: searchCompanyState,
            input: .init()
        )
        
        let model = EditProfileCompanyModel(
            searchCompanyState: searchCompanyState
        )
        let intent = EditProfileCompanyIntent(
            model: model,
            input: .init(userInfo: userInfo),
            searchCompanyIntent: searchCompanyIntent
        )
        let container = MVIContainer(
            intent: intent as EditProfileCompanyIntent.Intentable,
            model: model as EditProfileCompanyModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    public var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 20) {
                        if let userInfo = state.userInfo {
                            HStack {
                                Text("🏢 내 회사")
                                    .typography(.regular_12)
                                Text(userInfo.profile.companyName ?? "")
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
                        
                        SearchCompanyView(
                            state: state.searchCompanyState as! SearchCompanyModel,
                            intent: intent.searchCompanyIntent as! SearchCompanyIntent,
                            showDropDown: _showDropDown
                        )
                        .id(0)
                        
                        Spacer()
                            .frame(height: bottomSpacingHeight)
                            .id(1)
                            .onChange(of: showDropDown) {
                                if showDropDown {
                                    withAnimation {
                                        proxy.scrollTo(1)
                                    }
                                }
                            }
                            .foregroundStyle(.red)
                    }
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        withAnimation {
                            showDropDown = false
                        }
                    }
                }
            }
            CTABottomButton(
                title: "다음",
                isActive: state.searchCompanyState.isValidated
            ) {
                /// 회사를 정확하게 파악할 수 있다면 -> 같은 회사 매칭 팝업 보여주기
                if !state.searchCompanyState.isNoCompanyHere {
                    intent.showSameCompanyPopup()
                } else {
                    /// 회사 정확하게 파악 불가하다면 다음 뷰로
                    intent.onTapNextButton(state: state.searchCompanyState)
                }
            }
        }
        .navigationTitle("회사 수정")
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        EditProfileCompanyView(userInfo: .mock)
    }
}

//ZStack {
//    VStack {
//        if let userInfo = state.userInfo {
//            HStack {
//                Text("💼 내 직군")
//                    .typography(.regular_12)
//                Text(userInfo.profile.jobOccupation)
//                    .pretendard(
//                        weight: ._600,
//                        size: 12
//                    )
//            }
//            .foregroundStyle(DesignCore.Colors.grey400)
//            .padding(.horizontal, 20)
//            .padding(.vertical, 10)
//            .background(
//                Capsule()
//                    .fill(DesignCore.Colors.yellow50)
//                    .stroke(
//                        Color(hex: 0xEDE9C1),
//                        lineWidth: 1
//                    )
//            )
//            .padding(.vertical, 10)
//        }
//        JobSelectionView(
//            selected: [state.singleSelectedJob].compactMap { $0 }
//        ) { job in
//            intent.onTapJobOccupation(
//                selectedJob: job
//            )
//        }
//        .padding(.bottom, 90)
//    }
//
//    CTABottomButton(
//        title: "다음",
//        isActive: state.isValidated
//    ) {
//        intent.onTapNextButton(state: state)
//    }
//}
//.task {
//    await intent.task()
//}
//.onAppear {
//    intent.onAppear()
//}
//.ignoresSafeArea(.keyboard)
//.navigationTitle("직군 수정")
//.textureBackground()
//.setPopNavigation {
//    AppCoordinator.shared.pop()
//}
//.setLoading(state.isLoading)
