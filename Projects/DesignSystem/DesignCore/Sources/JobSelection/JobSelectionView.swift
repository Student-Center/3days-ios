//
//  JobSelectionView.swift
//  DesignCore
//
//  Created by 김지수 on 10/16/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct JobSelectionView: View {
    public var selected: [JobOccupation]
    public let handler: (JobOccupation) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public init(
        selected: [JobOccupation],
        handler: @escaping (JobOccupation) -> Void
    ) {
        self.selected = selected
        self.handler = handler
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(JobOccupation.allCases, id: \.self) { jobOccupation in
                    let isSelected = selected.contains { $0 == jobOccupation }
                    
                    VStack(spacing: 6) {
                        jobOccupation.icon
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(jobOccupation.name)
                            .typography(.medium_14)
                            .foregroundStyle(isSelected ? .white : DesignCore.Colors.grey400)
                    }
                    .frame(width: 96, height: 96)
                    .background(
                        iconBackground(isSelected: isSelected)
                    )
                    .onTapGesture {
                        handler(jobOccupation)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
    }
    
    @ViewBuilder
    func iconBackground(isSelected: Bool) -> some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 26)
                .stroke(.white, lineWidth: isSelected ? 10 : 5)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: 0xE1DDA5),
                            Color(hex: 0xC6C277),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(.default)
        } else {
            RoundedRectangle(cornerRadius: 26)
                .stroke(.white, lineWidth: isSelected ? 10 : 5)
                .fill(DesignCore.Colors.yellow50)
                .shadow(.default)
        }
    }
}
