//
//  GenderType.swift
//  SignUp
//
//  Created by 김지수 on 10/5/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

enum GenderType: CaseIterable {
    case male
    case female
    
    var unselectedImage: Image {
        switch self {
        case .male: DesignCore.Images.maleUnselected.image
        case .female: DesignCore.Images.femaleUnselected.image
        }
    }
    
    var selectedImage: Image {
        switch self {
        case .male: DesignCore.Images.maleSelected.image
        case .female: DesignCore.Images.femaleSelected.image
        }
    }
}
