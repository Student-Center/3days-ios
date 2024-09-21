//
//  String+Ext.swift
//  CoreKit
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

extension String {
    /// 한국 휴대폰 번호 형식에 맞는지 체크(8자리)
    public func isValidPhoneNumber() -> Bool {
        let number = self.replacingOccurrences(of: "-", with: "")
        let pattern = "^010\\d{8}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: number.utf16.count)
        return regex?.firstMatch(in: number, options: [], range: range) != nil

    }
    
    public func formattedPhoneNumber() -> String {
        let onlyNumbers = self.filter { $0.isNumber }
        
        let firstPart = String(onlyNumbers.prefix(3))
        let secondPart = String(onlyNumbers.dropFirst(3).prefix(4))
        let thirdPart = String(onlyNumbers.dropFirst(7).prefix(4))
        
        if onlyNumbers.count <= 3 {
            return firstPart
        } else if onlyNumbers.count <= 7 {
            return "\(firstPart)-\(secondPart)"
        } else {
            return "\(firstPart)-\(secondPart)-\(thirdPart)"
        }
    }
}
