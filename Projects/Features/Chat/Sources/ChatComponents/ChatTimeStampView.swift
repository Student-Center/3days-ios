//
//  ChatTimeStampView.swift
//  Chat
//
//  Created by 김지수 on 3/9/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct ChatTimeStampView: View {
    let timeStamp: String
    
    var body: some View {
        Text(timeStamp)
            .pretendard(weight: ._400, size: 10)
            .foregroundStyle(Color(hex: 0x534C44).opacity(0.5))
    }
}
