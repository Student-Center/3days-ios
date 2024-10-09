//
//  DropDownView.swift
//  DesignCore
//
//  Created by 김지수 on 10/9/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public protocol DropDownFetchable: Hashable, Equatable {
    var id: String { get }
    var name: String { get }
}

public struct DropDownPicker<Content: View>: View {
    
    @FocusState var showDropDown: Bool
    
    var tapHandler: ((Int) -> Void)?
    var content: () -> Content
    
    var dataSources: [any DropDownFetchable]
    let itemSize: CGFloat = 56
    
    var frameHeight: CGFloat {
        if !showDropDown {
            return 0
        }
        
        if dataSources.count > 3 {
            return itemSize * 3 + itemSize * 0.5
        }
        
        return itemSize * CGFloat(dataSources.count)
    }
    
    var frameOffset: CGFloat {
        if !showDropDown {
            return 0
        }
        
        if dataSources.count > 3 {
            return 140
        }
        
        return 125 - 28 * CGFloat(3 - dataSources.count)
    }
    
    public init(
        dataSources: [any DropDownFetchable],
        showDropDown: FocusState<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        tapHandler: ((Int) -> Void)? = nil
    ) {
        self.dataSources = dataSources
        self.content = content
        self.tapHandler = tapHandler
        self._showDropDown = showDropDown
    }
    
    public var body: some View {
        VStack {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.white) //
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(0 ..< dataSources.count, id: \.self) { index in
                                let item = dataSources[index]
                                Button(action: {
                                    tapHandler?(index)
                                    withAnimation {
                                        showDropDown.toggle()
                                    }
                                }, label: {
                                    HStack(spacing: 16) {
                                        Text(item.name)
                                            .typography(.regular_14)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .foregroundStyle(DesignCore.Colors.grey500)
                                    .frame(height: itemSize)
                                    .padding(.horizontal, 16)
                                    .background(.white)
                                })
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)

                )
                .shadow(.default)
                .animation(.easeInOut(duration: 0.2), value: frameOffset)
                .frame(height: frameHeight)
                .offset(y: frameOffset)
                
                content()
            }
            .frame(height: 50)
        }
    }
}
