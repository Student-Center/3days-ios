//
//  AgePickerView.swift
//  DesignCore
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct AgePickerView: View {
    @Binding var selectedValue: String?
    
    public init(selectedValue: Binding<String?>) {
        self._selectedValue = selectedValue
    }
    
    public var body: some View {
        Picker("숫자 선택", selection: $selectedValue) {
            Text("상관없어요")
                .tag(String?.none)
            ForEach(0...15, id: \.self) { number in
                Text("\(number)")
                    .tag(String?(String(number)))
            }
        }
        .pickerStyle(.wheel)
        .padding(.bottom)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}
