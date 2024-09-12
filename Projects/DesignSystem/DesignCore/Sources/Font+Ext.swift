//
//  Font+Ext.swift
//  DesignSystemKit
//
//  Created by 김지수 on 9/13/24.
//  Copyright © 2024 com.studentcenter. All rights reserved.
//

import SwiftUI
import UIKit

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
