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

public enum DateProfileTab: CaseIterable, Hashable {
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
    
    let partnerInfo: DreamPartnerInfo
    var editHandler: ((DateProfileTab) -> Void)?
    @State var dateProfileViewSelection: DateProfileTab = .ageRange

    func convertToString(age: Int?) -> String {
        guard let age,
              age != 0 else { return "상관없어요" }
        return "\(age)살"
    }
    
    public var body: some View {
        InBoxContainerView {
            VStack {
                TabView(selection: $dateProfileViewSelection) {
                    profileContentView(
                        title: dateProfileViewSelection.title,
                        needSpacing: true,
                        content: {
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
                        },
                        editHandler: {
                            editHandler?(DateProfileTab.ageRange)
                        }
                    )
                    .tag(DateProfileTab.ageRange)
                    
                    profileContentView(
                        title: dateProfileViewSelection.title,
                        needSpacing: false,
                        content: {
                            ZStack {
                                Color.clear
                                let jobOccupations = partnerInfo
                                    .jobOccupations
                                    .compactMap { JobOccupation(rawValue: $0) }
                                preferJobOccupationChips(jobs: jobOccupations)
                            }
                        },
                        editHandler: {
                            editHandler?(DateProfileTab.occupation)
                        }
                    )
                    .tag(DateProfileTab.occupation)
                    
                    profileContentView(
                        title: dateProfileViewSelection.title,
                        needSpacing: false,
                        content: {
                            ZStack {
                                Color.clear
                                LeftAlignText("🧭 \(partnerInfo.distanceType.description)")
                                    .typography(.medium_14)
                                    .foregroundStyle(DesignCore.Colors.grey400)
                            }
                        },
                        editHandler: {
                            editHandler?(DateProfileTab.distance)
                        }
                    )
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
        .overlay {
            DesignCore.Images.magnifyingGlass.image
                .resizable()
                .frame(width: 42, height: 42)
                .aspectRatio(contentMode: .fit)
                .offset(x: Device.width * 0.5 - 68, y: (156 * -0.5) + 10)
        }
        .frame(height: 156)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    func profileContentView(
        title: String,
        needSpacing: Bool,
        @ViewBuilder content: () -> some View,
        editHandler: @escaping () -> Void
    ) -> some View {
        VStack {
            HStack(spacing: 2) {
                Text(title)
                    .typography(.semibold_14)
                    .foregroundStyle(Color(hex: 0x534C44))
                    .frame(height: 20)
                DesignCore.Images.pencil1.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .onTapGesture {
                        editHandler()
                    }
                
                Spacer()
            }
            content()
            if needSpacing {
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func preferJobOccupationChips(jobs: [JobOccupation]) -> some View {
        HStack {
            ForEach(0 ..< jobs.count, id: \.self) { index in
                if index > 1 {
                    if index == 2 {
                        let remainCount = jobs.count - index
                        Text("외 \(remainCount)개")
                            .typography(.regular_14)
                            .foregroundStyle(DesignCore.Colors.grey400)
                            .padding(.all, 12)
                            .background(
                                Capsule()
                                    .fill(Color(hex: 0xF6DFFF))
                            )
                    }
                } else {
                    let job = jobs[index]
                    jobOccupationChip(job: job)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func jobOccupationChip(job: JobOccupation) -> some View {
        HStack {
            job.icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
            
            Text(job.name)
                .typography(.medium_14)
                .foregroundStyle(DesignCore.Colors.grey400)
        }
        .padding(.all, 12)
        .background(
            Capsule()
                .fill(.white)
                .stroke(Color(hex: 0xF3E3F9), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        DateProfilePanelView(partnerInfo: .mock)
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
