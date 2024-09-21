//
//  String+Ext.swift
//  CoreKit
//
//  Created by 김지수 on 9/21/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation

extension String {
    /// 한국 휴대폰 번호 형식에 맞는지 체크
    public func isValidPhoneNumber() -> Bool {
        let pattern = "^010-\\d{4}-\\d{4}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex?.firstMatch(in: self, options: [], range: range) != nil
    }
    
    public func formattedPhoneNumber() -> String {
        // 먼저 숫자인지 확인
        let onlyNumbers = self.filter { $0.isNumber }
        
        // 각 구간에 맞춰 자르기
        let firstPart = String(onlyNumbers.prefix(3))  // 3자리: 010
        let secondPart = String(onlyNumbers.dropFirst(3).prefix(4)) // 4자리까지: 0000
        let thirdPart = String(onlyNumbers.dropFirst(7).prefix(4))  // 마지막 4자리: 0000
        
        // 상황에 맞게 하이픈 붙이기
        if onlyNumbers.count <= 3 {
            return firstPart
        } else if onlyNumbers.count <= 7 {
            return "\(firstPart)-\(secondPart)"
        } else {
            return "\(firstPart)-\(secondPart)-\(thirdPart)"
        }
    }
}
