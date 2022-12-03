//
//  Date+.swift
//  CountdownBuddy
//
//  Created by Daniel Bonates on 03/12/22.
//

import Foundation

enum Interval: Double {
    case minute = 60
    case hour = 3600
    case day = 86400
    case week = 604800
    case year = 31556926
}

extension Date {
    func plusMinutes(_ minutes: Double) -> Date {
        let interval = timeIntervalSinceReferenceDate + (Interval.minute.rawValue * minutes)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func to(_ ammount: Double, by interval: Interval) -> Date {
        let interval = timeIntervalSinceReferenceDate + (interval.rawValue * ammount)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    static var localDate: Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {
            return nowUTC
        }
        return localDate
    }
    
    func localized() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {
            return self
        }
        return localDate
    }
}
