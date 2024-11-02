//
//  HomeMainTab.swift
//  Home
//
//  Created by 김지수 on 11/2/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

enum HomeMainTab: CaseIterable {
    case home
    case profile
}

extension HomeMainTab {
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .profile:
            return "Profile"
        }
    }
}
