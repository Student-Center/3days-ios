//
//  DesignPreview.swift
//  Main
//
//  Created by 김지수 on 8/17/24.
//

import SwiftUI
import DesignCore

fileprivate enum PreviewTypes: CaseIterable {
    case colors
    case typography
    
    var name: String {
        switch self {
        case .colors: return "Colors"
        case .typography: return "Typography"
        }
    }
    
    @ViewBuilder
    func nextView() -> some View {
        switch self {
        case .colors:
            DesignColorPreview()
        case .typography:
            DesignTypographyPreview()
        }
    }
}

public struct DesignPreviewView: View {

    public init() {}
    
    public var body: some View {
        NavigationStack {
            List(PreviewTypes.allCases, id: \.self) { type in
                NavigationLink {
                    type.nextView()
                } label: {
                    HStack {
                        Text(type.name)
                        Spacer()
                    }
                }
            }
            .navigationTitle("3days Design System")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DesignPreviewView()
}
