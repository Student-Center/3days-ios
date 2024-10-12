//
//  TagListRepresentable.swift
//  DesignCore
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import UIKit
import SwiftUI

public struct TagListView: UIViewRepresentable {
    var tagModels: [TagModel]
    var selectedTagModels: [TagModel]
    var onSelectedTag: (Int) -> Void
    
    public init(
        tagModels: [TagModel],
        selectedTagModels: [TagModel],
        onSelectedTag: @escaping (Int) -> Void
    ) {
        self.tagModels = tagModels
        self.selectedTagModels = selectedTagModels
        self.onSelectedTag = onSelectedTag
    }
    
    public func makeUIView(context: Context) -> TagListCollectionView {
        let tagListView = TagListCollectionView()
        tagListView.delegate = context.coordinator
        return tagListView
    }
    
    public func updateUIView(_ uiView: TagListCollectionView, context: Context) {
        uiView.setTags(tagModels.map { $0 })
        uiView.setSelectedTags(selectedTagModels.map { $0 })
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, TagListCollectionViewDelegate {
        var parent: TagListView
        
        public init(_ parent: TagListView) {
            self.parent = parent
        }
        
        public func tagListCollectionView(_ tagListCollectionView: TagListCollectionView, didSelectItemAt index: Int) {
            parent.onSelectedTag(index)
        }
    }
}
