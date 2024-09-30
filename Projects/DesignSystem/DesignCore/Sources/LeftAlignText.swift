//
//  LeftAlignText.swift
//  DesignCore
//
//  Created by 김지수 on 10/1/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct LeftAlignText: View {
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        HStack {
            Text(text)
            Spacer()
        }
    }
}
