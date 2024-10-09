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

struct DropDownMock: DropDownFetchable {
    let id: String
    var name: String
    
    static var mock: [DropDownMock] {
        return [
            .init(id: "0", name: "현대글로비스"),
            .init(id: "1", name: "현대자동차"),
            .init(id: "2", name: "기아자동차"),
            .init(id: "3", name: "채널"),
            .init(id: "4", name: "닥터다이어리"),
            .init(id: "5", name: "컬쳐커넥션"),
            .init(id: "6", name: "스타벅스"),
            .init(id: "7", name: "아이스아메리카노"),
            .init(id: "8", name: "애플"),
            .init(id: "9", name: "엔비디아"),
        ]
    }
}

public struct AuthCompanyView: View {
    
    @StateObject var container: MVIContainer<AuthCompanyIntent.Intentable, AuthCompanyModel.Stateful>
    
    private var intent: AuthCompanyIntent.Intentable { container.intent }
    private var state: AuthCompanyModel.Stateful { container.model }
    
    @FocusState var showDropDown: Bool
    @State var text: String = ""
    
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
                                dataSources: DropDownMock.mock,
                                showDropDown: _showDropDown
                            ) {
                                TextInput(
                                    placeholder: "내 회사 검색",
                                    text: $text,
                                    keyboardType: .namePhonePad,
                                    isFocused: _showDropDown
                                )
                                .interactiveDismissDisabled()
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .speechAnnouncementsQueued(false)
                                .speechSpellsOutCharacters(false)
                                
                            } tapHandler: { index in
                                print(index)
                                //                let university = viewStore.filteredUniversityLists[index]
                                //                viewStore.send(.didTappedUniversity(university: university))
                            }
                            .padding(.horizontal, 50)
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
                intent.onTapNextButton()
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
        AuthCompanyView()
    }
}
