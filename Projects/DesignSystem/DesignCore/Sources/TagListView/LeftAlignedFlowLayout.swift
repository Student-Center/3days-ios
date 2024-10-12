//
//  LeftAlignedFlowLayout.swift
//  DesignCore
//
//  Created by 김지수 on 10/12/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import UIKit

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY = -1.0
        attributes?.forEach { attribute in
            if attribute.representedElementCategory == .cell {
                if attribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                attribute.frame.origin.x = leftMargin
                leftMargin += attribute.frame.width + minimumInteritemSpacing
                maxY = max(attribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
