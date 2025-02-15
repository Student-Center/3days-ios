//
//  NavigationStack.swift
//  three-days-dev
//
//  Created by 김지수 on 9/30/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CommonKit
import SignUp
import Home
import Chat
import DesignPreview

extension PathType {
    @ViewBuilder
    var view: some View {
        switch self {
        case .designPreview:
            DesignPreviewView()
        case .authDebug:
            #if DEBUG || STAGING
            AuthDebugInfoView()
            #else
            EmptyView()
            #endif
        case .intro:
            SplashAnimatedView()
            
        // features
        case .home(let userInfo):
            HomeMainView(userInfo: userInfo)
            
        case .signUp(let subView):
            switch subView {
            case .authPhoneInput:
                AuthPhoneInputView()
            case .authPhoneVerify(let smsResponse):
                AuthPhoneVerifyView(smsResponse)
            case .authAgreement(let input):
                AuthAgreementView(input)
                
            case .profileIntro(let input):
                ProfileIntroView(input)
                
            case .authGreeting(let input):
                AuthGreetingView(input)
            case .authProfileGender(let input):
                AuthProfileGenderInputView(input)
            case .authProfileAge(let input):
                AuthProfileAgeInputView(input)
            case .authCompany(let input):
                AuthCompanyView(input)
            case .authJobOccupation(let input):
                AuthJobView(input)
            case .authRegion(let input):
                AuthRegionView(input)
            case .authName(let input):
                AuthNameInputView(input)
                
            case .dreamPartnerIntro(let input):
                DreamPartnerIntroView(input)
            case .dreamPartnerAgeRange(let input):
                DreamPartnerAgeView(input)
            case .dreamPartnerJobOccupation(let input):
                DreamPartnerJobView(input)
            case .dreamPartnerDistance(let input):
                DreamPartnerDistanceView(input)
            }
            
        case .editProfile(let subView):
            switch subView {
            case .profileImage(let input):
                EmptyView()
            case .jobOccupation(let input):
                EditProfileJobView(input)
            case .company(let input):
                EditProfileCompanyView(userInfo: input)
            case .region(let input):
                EditProfileRegionView(userInfo: input)
            }
            
        case .editDreamPartner(let subView):
            switch subView {
            case .ageRange(let userInfo):
                EditDateProfileAgeRangeView(userInfo: userInfo)
            case .jobOccupation(let userInfo):
                EditDateProfileJobView(userInfo)
            case .distance(let userInfo):
                EditDateProfileDistanceView(userInfo)
            }
            
        case .chat(let subView):
            switch subView {
            case .stompTestBed:
                ChattingView()
            }
        }
    }
}

extension AppCoordinator {
    @ViewBuilder
    var rootView: some View {
        navigationStack[0].view
    }
}
