//
//  Date+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

internal extension Date {
    
    @nonobjc static var currentCalendar = Foundation.Calendar.autoupdatingCurrent
    
    var ISO8601String: String {
        return ISO8601DateFormatter().string(from: self)
    }
    
    @nonobjc static let componentFlags: NSCalendar.Unit = [
        .year, .month, .day, .weekOfMonth, .weekOfYear,
        .hour, .minute, .second, .weekday, .weekdayOrdinal
    ]
    
    func isEqualToDateIgnoringTime(date: Date,
                                   calendar: Foundation.Calendar = Date.currentCalendar) -> Bool {
        let components1 = (calendar as NSCalendar).components(Date.componentFlags, from: self)
        let components2 = (calendar as NSCalendar).components(Date.componentFlags, from: date)
        return components1.year == components2.year
            && components1.month == components2.month
            && components1.day == components2.day
    }
    
    func amPMFormat() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = Date.is24HoursFormat ? "HH:mm" : "h:mm a"
        formatter.amSymbol = Date.is24HoursFormat ? "" : "AM"
        formatter.pmSymbol =  Date.is24HoursFormat ? "" : "PM"
        return formatter.string(from: self)
    }
    
    func components(fromDate date: Date, unitFlags: NSCalendar.Unit) -> DateComponents {
        return (Date.currentCalendar as NSCalendar).components(unitFlags,
                                                               from: date, to: self, options: [])
    }
    
    func adding(days: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return (Date.currentCalendar as NSCalendar)
            .date(byAdding: dateComponents, to: self, options: [])
    }
    
    func subtracting(days: Int) -> Date? {
        return adding(days: -days)
    }
    
    static func dateWithDaysBeforeNow(days: Int) -> Date? {
        return Date().subtracting(days: days)
    }
    
    static func dateYesterday() -> Date? {
        return Date.dateWithDaysBeforeNow(days: 1)
    }
    
    var isToday: Bool {
        return isEqualToDateIgnoringTime(date: Date())
    }
    
    var isYesterday: Bool {
        guard let yesterday = Date.dateYesterday() else {
            return false
        }
        return isEqualToDateIgnoringTime(date: yesterday)
    }
    
    func subtracting(hours: Int) -> Date? {
        return adding(hours: -hours)
    }
    
    func adding(hours: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.hour = hours
        return (Date.currentCalendar as NSCalendar)
            .date(byAdding: dateComponents, to: self, options: [])
    }
    
    func subtracting(minutes: Int) -> Date? {
        return adding(minutes: -minutes)
    }
    
    func adding(minutes: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.minute = minutes
        return (Date.currentCalendar as NSCalendar)
            .date(byAdding: dateComponents, to: self, options: [])
    }
    
    func subtracting(seconds: Int) -> Date? {
        return adding(seconds: -seconds)
    }
    
    func adding(seconds: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.second = seconds
        return (Date.currentCalendar as NSCalendar)
            .date(byAdding: dateComponents, to: self, options: [])
    }
    
    func rounding(toNearestMinutes nearestMinutes: Int) -> Date? {
        var components = (Date.currentCalendar as NSCalendar).components(Date.componentFlags, from: self)
        components.minute =
            Int(round(Float(components.minute!) / Float(nearestMinutes))) * nearestMinutes
        return Date.currentCalendar.date(from: components)
    }
    
    func dateFormatterExact(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateFormatter(_ format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        
        return dateFormatter.string(from: self)
    }
    
    func ISO8601DateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return formatter
    }

    func relativeDateString(uppercase: Bool = false) -> String {
        let years = Date().yearsFrom(self, timeZoneString: "UTC")
        let months = Date().monthsFrom(self, timeZoneString: "UTC")
        let days = Date().daysFrom(self, timeZoneString: "UTC")
        let hours = Date().hoursFrom(self, timeZoneString: "UTC")
        let minutes = Date().minutesFrom(self, timeZoneString: "UTC")
        
        if abs(years) == 0 {
            if abs(months) == 0 {
                if abs(days) == 0 {
                    if abs(hours) == 0 {
                        let momentsAgo = uppercase ? "Moments ago".localize() : "moments ago".localize()
                        return abs(minutes) < 1 ? momentsAgo : String(format: "%d minutes ago".localize(), abs(minutes))
                    } else {
                        return (1 ... 2).contains(abs(hours)) ? "1 hour ago".localize() : String(format: "%d hours ago".localize(), abs(hours))
                    }
                } else {
                    let yesterday = uppercase ? "Yesterday".localize() : "yesterday".localize()
                    return abs(days) == 1 ? yesterday : String(format: "%d days ago".localize(), abs(days))
                }
            } else {
                return abs(months) == 1 ? "1 month ago".localize() : String(format: "%d months ago".localize(), abs(months))
            }
        } else {
            return abs(years) == 1 ? "1 year ago".localize() : String(format: "%d years ago".localize(), abs(years))
        }
    }
    
	static func from24ToLocalTime(_ time: String) -> String {
		
		if Date.is24HoursFormat {
			return time
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let date = dateFormatter.string(from: Date())
		
		let newDateString = "\(date) \(time)"
		
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		
		if let newDate = dateFormatter.date(from: newDateString) {
			// Convert to string
			dateFormatter.dateFormat = "h:mm a"
			let newTime = dateFormatter.string(from: newDate)
			
			return newTime.lowercased()
		}
		
		return time
	}
    
    static var is24HoursFormat : Bool {
        let format = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.autoupdatingCurrent)
        return !format!.contains("a")
    }
    
    static func converDateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)
    }
}

extension Date {

    // string can be abbreviation or long strong
    func changeTimeZone(string:String?) -> Date {
        let timeZoneString = TimeZone.abbreviationDictionary.filter { $0.key == string || $0.value == string }.first?.key ?? ""
        
        return (Calendar(timeZoneString) as NSCalendar).date(byAdding: .day, value: 0, to: self)!
    }
    
    func Calendar(_ timeZoneString: String? = Foundation.Calendar.current.timeZone.abbreviation()) -> Foundation.Calendar {
        var calendar = Foundation.Calendar.current
        
        if let timeZoneString = timeZoneString, let timeZone = TimeZone(abbreviation: timeZoneString) {
            calendar.timeZone = timeZone
        }
        
        return calendar
    }
    
    func yearsFrom(_ date: Date, timeZoneString: String?) -> Int {
        return (Calendar(timeZoneString) as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date: Date, timeZoneString: String?) -> Int {
        return (Calendar(timeZoneString) as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date: Date, timeZoneString: String?) -> Int {
        return (Calendar(timeZoneString) as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date: Date, timeZoneString: String?) -> Int {
        return (Calendar(timeZoneString) as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date: Date, timeZoneString: String?) -> Int {
        return (Calendar(timeZoneString) as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date: Date, timeZoneString: String?) -> Int{
        return (Calendar(timeZoneString) as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date: Date, timeZoneString: String?) -> Int{
        return (Calendar(timeZoneString) as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func yesterday(timeZoneString: String? = Foundation.Calendar.current.timeZone.abbreviation()) -> Date {
        return (Calendar(timeZoneString) as NSCalendar).date(byAdding: .day, value: -1, to: noon())!
    }
    func tomorrow(timeZoneString: String? = Foundation.Calendar.current.timeZone.abbreviation()) -> Date {
        return (Calendar(timeZoneString) as NSCalendar).date(byAdding: .day, value: 1, to: noon())!
    }
    func noon(timeZoneString: String? = Foundation.Calendar.current.timeZone.abbreviation()) -> Date {
        return (Calendar(timeZoneString) as NSCalendar).date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    func midnight(timeZoneString: String? = Foundation.Calendar.current.timeZone.abbreviation()) -> Date {
        return (Calendar(timeZoneString) as NSCalendar).startOfDay(for: tomorrow())
    }
    func endOfTheDay(timeZoneString: String? = Foundation.Calendar.current.timeZone.abbreviation()) -> Date {
        return (Calendar(timeZoneString) as NSCalendar).date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    func startOfTheDay(timeZoneString: String? = Foundation.Calendar.current.timeZone.abbreviation()) -> Date {
        return (Calendar(timeZoneString) as NSCalendar).date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}

