//
//  DesignBackgroundTextureView.swift
//  DesignPreview
//
//  Created by 김지수 on 9/18/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import DesignCore

struct DesignBackgroundTextureView: View {
    var body: some View {
        ZStack {
            Text("This is Background 🎨")
                .typography(.semibold_20)
        }
        .textureBackground()
        .navigationTitle("Texture Background")
    }
}

#Preview {
    DesignBackgroundTextureView()
}
