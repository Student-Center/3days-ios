//
//  DateConverter.swift
//  CoreKit
//
//  Created by 김지수 on 2/22/25.
//  Copyright © 2025 com.weave. All rights reserved.
//

import Foundation

public enum DateConverter {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 m분"
        return formatter
    }()
    
    public static func dateToString(
        date: Date?,
        format: String = "a h시 m분"
    ) -> String {
        guard let date else { return "" }
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public static func stringToDate(
        string: String,
        format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    ) -> Date? {
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
}
