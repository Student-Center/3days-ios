//
//  AuthCompanyView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct AuthCompanyView: View {
    
    @StateObject var container: MVIContainer<AuthCompanyIntent.Intentable, AuthCompanyModel.Stateful>
    
    private var intent: AuthCompanyIntent.Intentable { container.intent }
    private var state: AuthCompanyModel.Stateful { container.model }
    
    @FocusState var showDropDown: Bool
    @State var isShowSameCompanyPopup = false
    
    public init() {
        let model = AuthCompanyModel()
        let intent = AuthCompanyIntent(
            model: model,
            input: .init()
        )
        let container = MVIContainer(
            intent: intent as AuthCompanyIntent.Intentable,
            model: model as AuthCompanyModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    var bottomSpacingHeight: CGFloat {
        return showDropDown ? Device.height * 0.7 : 0
    }
    
    var textInputRightIcon: TextInputRightIconModel {
        if state.selectedCompany != nil {
            return .init(
                icon: DesignCore.Images.checkBold.image,
                backgroundColor: Color(hex: 0x2DE76B)
            )
        } else {
            return .init(
                icon: DesignCore.Images.search.image,
                backgroundColor: .init(hex: 0xCAC7C5)
            )
        }
    }
    
    public var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        ProfileInputTemplatedView(
                            currentPage: 3,
                            maxPage: 5,
                            subMessage: "운명의 상대를 만나기 딱 좋은 나이네요.",
                            mainMessage: "당신은 지금 어떤 회사에서\n재직하고 있나요?"
                        ) {
                            DropDownPicker(
                                dataSources: state.searchResponse,
                                showDropDown: _showDropDown,
                                needCallNextPage: state.needPagination
                            ) {
                                TextInput(
                                    placeholder: "내 회사 검색",
                                    text: $container.model.textInput,
                                    keyboardType: .namePhonePad,
                                    isFocused: _showDropDown,
                                    isEnabled: state.isTextFieldEnabled,
                                    rightIcon: textInputRightIcon
                                )
                                .interactiveDismissDisabled()
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .speechAnnouncementsQueued(false)
                                .speechSpellsOutCharacters(false)
                            } tapHandler: { index in
                                let company = state.searchResponse[index]
                                intent.onCompanySelected(
                                    company: company
                                )
                            } nextPageHandler: {
                                if let nextSearchKey = state.nextSearchKey {
                                    print("\(nextSearchKey)로 호출")
                                    intent.needRequestNextPage(
                                        keyword: state.textInput,
                                        next: nextSearchKey
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                            .onChange(of: state.isTextFieldFocused) {
                                showDropDown = state.isTextFieldFocused
                            }
                            .onChange(of: showDropDown) {
                                intent.onChangedFocusState(showDropDown)
                            }
                            
                            HStack {
                                Spacer()
                                Image(systemName: state.isNoCompanyHere ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .foregroundStyle(DesignCore.Colors.grey200)
                                Text("회사 검색 목록에 없어요.")
                                    .typography(.medium_14)
                                    .foregroundStyle(DesignCore.Colors.grey400)
                                Spacer()
                            }
                            .padding(.horizontal, 60)
                            .padding(.vertical, 14)
                            .background(DesignCore.Colors.grey100.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 24)
                            .contentShape(Rectangle())
                            .padding(.top, 12)
                            .onTapGesture {
                                intent.onTapNoCompanyToggle()
                            }
                        }
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
                    .onTapGesture {
                        withAnimation {
                            showDropDown = false
                        }
                    }
                }
            }
            CTABottomButton(
                title: "다음",
                isActive: state.isValidated
            ) {
                /// 회사를 정확하게 파악할 수 있다면 -> 같은 회사 매칭 팝업 보여주기
                if !state.isNoCompanyHere {
                    isShowSameCompanyPopup = true
                } else {
                    /// 회사 정확하게 파악 불가하다면 다음 뷰로
                    intent.onTapNextButton()
                }
            }
        }
        .sheet(isPresented: $isShowSameCompanyPopup) {
            sameCompanyMatchingPopUpView
                .presentationDetents([.height(280)])
                .presentationCornerRadius(20)
        }
        .onChange(of: state.textInput) {
            intent.onTextChanged(text: state.textInput)
        }
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
    
    @ViewBuilder
    var sameCompanyMatchingPopUpView: some View {
        VStack {
            VStack(spacing: 0) {
                LeftAlignText("잠시만요!")
                    .typography(.regular_14)
                    .foregroundStyle(DesignCore.Colors.grey200)
                LeftAlignText("같은 회사 사람도 소개 받을까요?")
                    .typography(.semibold_20)
                    .foregroundStyle(DesignCore.Colors.grey500)
            }
            
            Spacer()
            
            VStack {
                CTAButton(
                    title: "같은 회사는 소개받기 싫어요",
                    backgroundStyle: DesignCore.Colors.red300
                ) {
                    intent.onTapSameCompanyMatching(isAgree: false)
                    isShowSameCompanyPopup = false
                    intent.onTapNextButton()
                }
                
                CTAButton(
                    title: "네, 받을래요",
                    titleColor: DesignCore.Colors.grey400,
                    backgroundStyle: DesignCore.Colors.grey50
                ) {
                    intent.onTapSameCompanyMatching(isAgree: true)
                    isShowSameCompanyPopup = false
                    intent.onTapNextButton()
                }
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 30)
    }
}

#Preview {
    NavigationView {
        AuthCompanyView()
    }
}
