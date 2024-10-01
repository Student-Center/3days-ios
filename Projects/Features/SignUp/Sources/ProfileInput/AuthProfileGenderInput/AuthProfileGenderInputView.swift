//
//  AuthProfileGenderInputView.swift
//  DesignPreview
//
//  Created by 김지수 on 10/1/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

enum GenderType: CaseIterable {
    case male
    case femail
    
    var unselectedImage: Image {
        switch self {
        case .male: DesignCore.Images.maleUnselected.image
        case .femail: DesignCore.Images.femaleUnselected.image
        }
    }
    
    var selectedImage: Image {
        switch self {
        case .male: DesignCore.Images.maleSelected.image
        case .femail: DesignCore.Images.femaleSelected.image
        }
    }
}

public struct AuthProfileGenderInputView: View {
    @State var selectedGender: GenderType?
    
    public init() {}
    
    public var body: some View {
        VStack {
            ProfileInputTemplatedView(
                currentPage: 1,
                maxPage: 5,
                subMessage: "만나서 반가워요!",
                mainMessage: "당신의 성별은 무엇인가요?"
            ) {
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(GenderType.allCases, id: \.self) {  type in
                        if selectedGender == type {
                            type.selectedImage
                                .resizable()
                                .frame(width: 130, height: 130)
                        } else {
                            type.unselectedImage
                                .resizable()
                                .frame(width: 130, height: 130)
                                .onTapGesture {
                                    withAnimation {
                                        selectedGender = type
                                    }
                                }
                        }
                    }
                    Spacer()
                }
            }
            
            Spacer()
            
            CTABottomButton(
                title: "다음",
                isActive: selectedGender != nil
            ) {
                
            }
        }
        .padding(.top, 10)
        .textureBackground()
        .setNavigation(showLeftBackButton: false) {
            
        }
    }
}

#Preview {
    NavigationView {
        AuthProfileGenderInputView()
    }
}
