//
//  EditDateProfileAgeRangeView.swift
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

public struct EditDateProfileAgeRangeView: View {
    
    @StateObject var container: MVIContainer<EditDateProfileAgeRangeIntent.Intentable, EditDateProfileAgeRangeModel.Stateful>
    
    private var intent: EditDateProfileAgeRangeIntent.Intentable { container.intent }
    private var state: EditDateProfileAgeRangeModel.Stateful { container.model }
    
    public init(userInfo: UserInfo) {
        let model = EditDateProfileAgeRangeModel()
        let intent = EditDateProfileAgeRangeIntent(
            model: model,
            input: .init(userInfo: userInfo)
        )
        let container = MVIContainer(
            intent: intent as EditDateProfileAgeRangeIntent.Intentable,
            model: model as EditDateProfileAgeRangeModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }
    
    @State private var upperValue: String?
    @State private var lowerValue: String?
    @State private var showUpperPicker = true
    @State private var showLowerPicker = false
    
    public var body: some View {
        ZStack {
            VStack {
                AgeUpDownView(
                    type: .up,
                    upperValue: upperValue,
                    lowerValue: lowerValue,
                    showPicker: showUpperPicker
                )
                .onTapGesture {
                    showUpperPicker = true
                    showLowerPicker = false
                }
                AgeUpDownView(
                    type: .down,
                    upperValue: upperValue,
                    lowerValue: lowerValue,
                    showPicker: showLowerPicker
                )
                .onTapGesture {
                    showUpperPicker = false
                    showLowerPicker = true
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            
            if showUpperPicker || showLowerPicker {
                VStack {
                    Spacer()
                    AgePickerView(
                        selectedValue: showUpperPicker ? $upperValue : $lowerValue
                    )
                    .padding(.bottom, 90)
                    .frame(height: 300)
                }
                .transition(.move(edge: .bottom))
                .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                CTABottomButton(
                    title: "다음",
                    isActive: state.isValidated
                ) {
                    intent.onTapNextButton(state: state)
                }
            }
        }
        .onChange(of: upperValue) {
            intent.onChangeUpperValue(value: upperValue)
        }
        .onChange(of: lowerValue) {
            intent.onChangeLowerValue(value: lowerValue)
        }
        .onChange(of: state.upperValue) {
            upperValue = state.upperValue
        }
        .onChange(of: state.lowerValue) {
            lowerValue = state.lowerValue
        }
        .task {
            await intent.task()
        }
        .onAppear {
            intent.onAppear()
        }
        .navigationTitle("선호 연령 수정")
        .ignoresSafeArea(.keyboard)
        .textureBackground()
        .setPopNavigation {
            AppCoordinator.shared.pop()
        }
        .setLoading(state.isLoading)
    }
}

#Preview {
    NavigationView {
        EditDateProfileAgeRangeView(userInfo: .mock)
    }
}
