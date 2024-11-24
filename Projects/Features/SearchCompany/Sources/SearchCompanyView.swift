//
//  SearchCompanyView.swift
//  SearchCompany
//
//  Created by 김지수 on 11/24/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit

public struct SearchCompanyView: View {
    
    @StateObject var container: MVIContainer<SearchCompanyIntent.Intentable, SearchCompanyModel.Stateful>
    @FocusState var showDropDown: Bool
    
    private var intent: SearchCompanyIntent.Intentable { container.intent }
    private var state: SearchCompanyModel.Stateful { container.model }
    
    public init(
        state: SearchCompanyModel,
        intent: SearchCompanyIntent,
        showDropDown: FocusState<Bool>
    ) {
        let container = MVIContainer(
            intent: intent as SearchCompanyIntent.Intentable,
            model: state as SearchCompanyModel.Stateful,
            modelChangePublisher: state.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
        self._showDropDown = showDropDown
    }
    
    public init() {
        let model = SearchCompanyModel()
        let intent = SearchCompanyIntent(
            model: model,
            input: .init()
        )
        self.init(
            state: .init(),
            intent: intent,
            showDropDown: .init()
        )
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
        VStack(spacing: 20) {
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
                .flatTextFieldOption(keyboardType: .namePhonePad)
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
            .onChange(of: state.textInput) {
                print(state.textInput)
                intent.onTextChanged(text: state.textInput)
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
            .sheet(isPresented: $container.model.isShowSameCompanyPopup) {
                sameCompanyMatchingPopUpView
                    .presentationDetents([.height(280)])
                    .presentationCornerRadius(20)
            }
        }
        .onAppear {
            intent.onAppear()
        }
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
                    intent.closeSameCompanyPopup()
                    intent.onTapNextButton(state: state)
                }
                
                CTAButton(
                    title: "네, 받을래요",
                    titleColor: DesignCore.Colors.grey400,
                    backgroundStyle: DesignCore.Colors.grey50
                ) {
                    intent.onTapSameCompanyMatching(isAgree: true)
                    intent.closeSameCompanyPopup()
                    intent.onTapNextButton(state: state)
                }
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 30)
    }
}

#Preview {
    NavigationView {
        SearchCompanyView()
    }
}
