//
//  FlatTextFieldOption.swift
//  DesignCore
//
//  Created by 김지수 on 11/14/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

struct FlatTextFieldOptionModifier: ViewModifier {
    let keyboardType: UIKeyboardType
    
    func body(content: Content) -> some View {
        content
            .keyboardType(keyboardType)
            .interactiveDismissDisabled()
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .speechAnnouncementsQueued(false)
            .speechSpellsOutCharacters(false)
    }
}

extension View {
    public func flatTextFieldOption(keyboardType: UIKeyboardType = .default) -> some View {
        modifier(FlatTextFieldOptionModifier(keyboardType: keyboardType))
    }
}
