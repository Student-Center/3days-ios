//
//  DateProfilePanelView.swift
//  Home
//
//  Created by 김지수 on 11/22/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import DesignCore
import CommonKit
import Model

enum DateProfileTab: CaseIterable, Hashable {
    case ageRange
    case occupation
    case distance
    
    var title: String {
        switch self {
        case .ageRange: return "나의 선호 연령"
        case .occupation: return "나의 선호 직군"
        case .distance: return "나의 선호 거리"
        }
    }
}

public struct DateProfilePanelView: View {
    
    @StateObject var container: MVIContainer<DateProfilePanelIntent.Intentable, DateProfilePanelModel.Stateful>
    @State var dateProfileViewSelection: DateProfileTab = .ageRange
    
    private var intent: DateProfilePanelIntent.Intentable { container.intent }
    private var state: DateProfilePanelModel.Stateful { container.model }
    
    public init(_ dreamPartnerInfo: DreamPartnerInfo) {
        let model = DateProfilePanelModel()
        let intent = DateProfilePanelIntent(
            model: model,
            input: .init(dreamPartnerInfo: dreamPartnerInfo)
        )
        let container = MVIContainer(
            intent: intent as DateProfilePanelIntent.Intentable,
            model: model as DateProfilePanelModel.Stateful,
            modelChangePublisher: model.objectWillChange
        )
        self._container = StateObject(wrappedValue: container)
    }

    func convertToString(age: Int?) -> String {
        guard let age,
              age != 0 else { return "상관없어요" }
        return "\(age)살"
    }
    
    public var body: some View {
        InBoxContainerView {
            if let partnerInfo = state.dreamPartnerInfo {
                VStack {
                    TabView(selection: $dateProfileViewSelection) {
                        profileContentView(
                            title: dateProfileViewSelection.title,
                            needSpacing: true
                        ) {
                            VStack(spacing: 10) {
                                HStack(spacing: 0) {
                                    Text("👆 내 나이보다 ")
                                        .foregroundStyle(DesignCore.Colors.grey300)
                                    let upperAgeString = convertToString(age: partnerInfo.upperBirthYear)
                                    Text("**위로 \(upperAgeString)**")
                                        .foregroundStyle(DesignCore.Colors.green500)
                                    Spacer()
                                }
                                HStack(spacing: 0) {
                                    Text("👇 내 나이보다 ")
                                        .foregroundStyle(DesignCore.Colors.grey300)
                                    let lowerAgeString = convertToString(age: partnerInfo.lowerBirthYear)
                                    Text("**아래로 \(lowerAgeString)**")
                                        .foregroundStyle(DesignCore.Colors.pink500)
                                    Spacer()
                                }
                            }
                            .typography(.regular_14)
                        }
                        .tag(DateProfileTab.ageRange)
                        
                        profileContentView(
                            title: dateProfileViewSelection.title,
                            needSpacing: false
                        ) {
                            
                        }
                        .tag(DateProfileTab.occupation)
                        
                        profileContentView(
                            title: dateProfileViewSelection.title,
                            needSpacing: false
                        ) {
                            ZStack {
                                Color.clear
                                LeftAlignText("🧭 \(partnerInfo.distanceType.description)")
                                    .typography(.medium_14)
                                    .foregroundStyle(DesignCore.Colors.grey400)
                            }
                        }
                        .tag(DateProfileTab.distance)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    if let currentPage = DateProfileTab.allCases.firstIndex(where: { dateProfileViewSelection == $0 }) {
                        CustomPageIndicator(
                            numberOfPages: DateProfileTab.allCases.count,
                            currentPage: currentPage
                        )
                    }
                }
            }
        }
        .frame(height: 156)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    func profileContentView(
        title: String,
        needSpacing: Bool,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack {
            LeftAlignText(title)
                .typography(.semibold_14)
                .foregroundStyle(Color(hex: 0x534C44))
                .frame(height: 20)
            content()
            if needSpacing {
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationView {
        DateProfilePanelView(.mock)
            .padding(.horizontal, 20)
    }
}

public struct InBoxContainerView<ContentView: View>: View {
    
    @ViewBuilder var contentView: () -> ContentView
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
                .shadow(.default)
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: 0xFBF0FF))
                    .padding(.all, 7)
                contentView()
                    .padding(.all, 24)
            }
        }
    }
}

struct CustomPageIndicator: View {
   let numberOfPages: Int
   let currentPage: Int
   
   var body: some View {
       HStack(spacing: 4) {
           ForEach(0 ..< numberOfPages, id: \.self) { page in
               Circle()
                   .fill(page == currentPage ? Color(Color(hex: 0xDA96F3)) : Color(hex: 0x454545).opacity(0.12))
                   .frame(width: 5, height: 5)
           }
       }
   }
}
