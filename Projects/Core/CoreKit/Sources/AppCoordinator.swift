//
//  AppCoordinator.swift
//  CoreKit
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

@Observable public final class AppCoordinator {
    //MARK: - Lifecycle
    public static var shared = AppCoordinator()
    private init() {}
    
    //MARK: - Properties
    public private(set) var rootView = FeatureType.main
    
    //MARK: - Methods
    public func changeRootView(_ feature: FeatureType) {
        rootView = feature
    }
}
