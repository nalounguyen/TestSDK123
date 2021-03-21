//
//  Date+Extension.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation

extension Date {
    static let formatter = DateFormatter()
    static let numFormatter = NumberFormatter()

    /// Converts Date to String (yyyy/MM/dd)
    func toString() -> String {
        Date.formatter.locale = Locale(identifier: "en_US_POSIX")
        Date.formatter.dateFormat = "yyyy/MM/dd"
        //setLocalizedDateFormatFromTemplate("yMd")
        return Date.formatter.string(from: self)
    }
    
    func toString(withFormat: String) -> String {
        Date.formatter.locale = Locale.current
        Date.formatter.dateFormat = withFormat
        return Date.formatter.string(from: self)
    }
    
    func toLocalizedDate(withFormat: String) -> String {
        if let langCode = Locale.current.languageCode {
            Date.formatter.locale = Locale(identifier: "\(langCode)")
        }else {
            Date.formatter.locale = Locale.current
        }
        Date.formatter.setLocalizedDateFormatFromTemplate(withFormat)
        return Date.formatter.string(from: self)
    }
    
    func toISO() -> String {
        Date.formatter.locale = Locale(identifier: "en_US_POSIX")
        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        //setLocalizedDateFormatFromTemplate("yMd")
        return Date.formatter.string(from: self)
    }
    
    func monthName() -> String {
        Date.formatter.setLocalizedDateFormatFromTemplate("yMMMM")
        return Date.formatter.string(from: self)
    }
    
    /// Converts Date to String (E, dd/MM/yyyy - HH:mm) and format via location of device
    func toDetailString() -> String {
        Date.formatter.locale = Locale.current
        Date.formatter.setLocalizedDateFormatFromTemplate("E, dd/MM/yyyy - HH:mm")
        return Date.formatter.string(from: self)
    }
    
    static func fromUnixtime(_ ts: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(ts))
        return date.toString()
    }
    
    static func convert(iso8601: String) -> Date? {
        Date.formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: iso8601)
    }
    
    /// This converts a string value to ISO datetime
    static func convertFromISO(_ dateStr: String) -> Date? {
        Date.formatter.locale = Locale(identifier: "en_US_POSIX")
        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter.date(from: dateStr)
    }
    
    func daySuffix() -> String {
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components(.day, from: self)
            let dayOfMonth = components.day
            switch dayOfMonth {
            case 1, 21, 31:
                return "st"
            case 2, 22:
                return "nd"
            case 3, 23:
                return "rd"
            default:
                return "th"
            }
        }
}
