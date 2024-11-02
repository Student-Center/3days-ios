//
//  HomeMainIntent.swift
//  DesignPreview
//
//  Created by 김지수 on 11/2/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit

//MARK: - Intent
class HomeMainIntent {
    private weak var model: HomeMainModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: HomeMainModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
    }
}

//MARK: - Intentable
extension HomeMainIntent {
    protocol Intentable {
        // content
        func onTapTab(_ tab: HomeMainTab)
        func onTapNextButton()
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {}
}

//MARK: - Intentable
extension HomeMainIntent: HomeMainIntent.Intentable {
    // default
    func onTapTab(_ tab: HomeMainTab) {
        model?.setSelectedTab(tab: tab)
    }
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapNextButton() {}
}
