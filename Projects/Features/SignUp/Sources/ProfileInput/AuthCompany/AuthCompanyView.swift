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
import Model
import SearchCompany

public struct AuthCompanyView: View {
    
    @StateObject var container: MVIContainer<AuthCompanyIntent.Intentable, AuthCompanyModel.Stateful>
    
    private var intent: AuthCompanyIntent.Intentable { container.intent }
    private var state: AuthCompanyModel.Stateful { container.model }
    
    @FocusState var showDropDown: Bool
    
    public init(_ input: SignUpFormDomain) {
        let searchCompanyState = SearchCompanyModel()
        let searchCompanyIntent = SearchCompanyIntent(
            model: searchCompanyState,
            input: .init()
        )
        
        let model = AuthCompanyModel(searchCompanyState: searchCompanyState)
        let intent = AuthCompanyIntent(
            model: model,
            input: .init(input: input),
            searchCompanyIntent: searchCompanyIntent
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
                            SearchCompanyView(
                                state: state.searchCompanyState as! SearchCompanyModel,
                                intent: intent.searchCompanyIntent as! SearchCompanyIntent,
                                showDropDown: _showDropDown
                            )
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
        AuthCompanyView(.mock)
    }
}
