//
//  TagListCollectionView.swift
//  DesignCore
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import UIKit
import SwiftUI

public struct TagModel: Identifiable, Hashable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

public protocol TagListCollectionViewDelegate: AnyObject {
    func tagListCollectionView(_ tagListCollectionView: TagListCollectionView, didSelectItemAt index: Int)
}

public class TagListCollectionView: UIView {
    weak var delegate: TagListCollectionViewDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.register(
            TagListCollectionViewCell.self,
            forCellWithReuseIdentifier: TagListCollectionViewCell.identifier
        )
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private var tags: [TagModel] = []
    private var selectedTags: [TagModel] = []
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func setTags(_ tags: [TagModel]) {
        self.tags = tags
        collectionView.reloadData()
    }
    
    public func setSelectedTags(_ selectedTags: [TagModel]) {
        self.selectedTags = selectedTags
        collectionView.reloadData()
    }
}

extension TagListCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagListCollectionViewCell.identifier,
            for: indexPath
        ) as? TagListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let tag = tags[indexPath.item]
        cell.configure(
            with: tag.name,
            isSelected: selectedTags.contains(tag)
        )
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tagListCollectionView(self, didSelectItemAt: indexPath.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tags[indexPath.item]
        let label: UILabel = {
            let label = UILabel()
            label.font = UIFont.pretendard(._500, size: 14)
            label.textAlignment = .center
            return label
        }()
        label.text = tag.name
        label.sizeToFit()
        return CGSize(
            width: label.frame.size.width + 24,
            height: 40
        )
    }
}
