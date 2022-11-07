//
//  TimeFormatter.swift
//  TaskManager
//
//  Created by vbugrym on 07.10.2022.
//

import Foundation

enum DateTimeFormatter {
    static let dateTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM yyyy"
        formatter.locale = Locale(identifier: "en_GB")
        formatter.timeZone = TimeZone(identifier: "Europe/London")
        return formatter
    }
    
    static func timeString(from date: Date) -> String {
        let formatter = dateTimeFormatter()
        let string = formatter.string(from: date)
        return string
    }
}
