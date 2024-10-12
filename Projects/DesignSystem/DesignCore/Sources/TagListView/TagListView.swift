//
//  TagListView.swift
//  DesignCore
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI

public struct CustomTagListView<Content: View>: View {
    
    /// An array of Tag View
    private let tagViews: [CustomTagSingleView<Content>]
    /// Horizontal space between each tag
    private let horizontalSpace: CGFloat
    /// Vertical space between each tag
    private let verticalSpace: CGFloat
    
    @State private var listHeight: CGFloat = 0
    
    public init(_ views: [CustomTagSingleView<Content>],
                horizontalSpace: CGFloat,
                verticalSpace: CGFloat) {
        self.tagViews = views
        self.horizontalSpace = horizontalSpace
        self.verticalSpace = verticalSpace
    }
    
    public var body: some View {
        GeometryReader { geometry in
            generateTags(geometry, views: tagViews)
                .background(GeometryReader { geo in
                    Color(.clear)
                        .onAppear {
                            self.listHeight = geo.size.height
                        }
                })
        }
        .frame(height: listHeight)
    }
    
    private func generateTags(
        _ geometry: GeometryProxy,
        views: [CustomTagSingleView<Content>]
    ) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
     
        return ZStack(alignment: .topLeading) {
            ForEach(views, id: \.self) { view in
                view
                    .padding(.trailing, horizontalSpace)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height + verticalSpace
                        }
                        let result = width
                        if view == views.last {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if view == views.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
    }
}

public struct CustomTagSingleView<Content: View>: View, Hashable {
    
    private let id = UUID()
    @State private var content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        _content = State(initialValue: content())
    }
    
    public var body: some View {
        content
    }
    
    public static func == (lhs: CustomTagSingleView, rhs: CustomTagSingleView) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
