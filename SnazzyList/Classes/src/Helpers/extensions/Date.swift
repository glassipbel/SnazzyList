//
//  Date.swift
//  Noteworth2
//
//  Created by Kevin on 12/20/18.
//  Copyright © 2018 Noteworth. All rights reserved.
//

import Foundation

extension TimeZone {
    func offsetFromUTC() -> String {
        let localTimeZoneFormatter = DateFormatter.getDefaultFormatter(format: "Z", timeZone: self)
        return localTimeZoneFormatter.string(from: Date())
    }
    
    func offsetInHours() -> String {
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}

extension TimeInterval {
    var timeComponents: (h: Int, m: Int, s: Int) {
        let seconds = Int(self)
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

extension Date {
    static func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second
        
        return calendar.date(from: mergedComponents)
    }
    
    func dateOnly() -> Date {
        let components = NSCalendar.current.dateComponents([.year, .month, .day], from: self)
        let date = NSCalendar.current.date(from: components)
        return date!
    }
    
    func isEqual(to date: Date, granularity: Calendar.Component) -> Bool {
        return NSCalendar.current.compare(self, to: date, toGranularity: granularity) == .orderedSame
    }
    
    func isGreater(than date: Date, granularity: Calendar.Component) -> Bool {
        return NSCalendar.current.compare(self, to: date, toGranularity: granularity) == .orderedDescending
    }
    
    func isSmaller(than date: Date, granularity: Calendar.Component) -> Bool {
        return NSCalendar.current.compare(self, to: date, toGranularity: granularity) == .orderedAscending
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }
    
    func added(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }
    
    func added(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func added(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self) ?? self
    }
    
    func added(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
    
    func added(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self) ?? self
    }
    
    var isFuture: Bool {
        return self > Date()
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var year: Int {
        return calendar.component(.year, from: self)
    }
    
    var month: Int {
        return calendar.component(.month, from: self)
    }
    
    var day: Int {
        return calendar.component(.day, from: self)
    }
    
    var hour: Int {
        return calendar.component(.hour, from: self)
    }
    
    var minutes: Int {
        return calendar.component(.minute, from: self)
    }
    
    var seconds: Int {
        return calendar.component(.second, from: self)
    }
    
    var hourMinutesAndSecondsInSeconds: Int {
        return (self.hour * 60 * 60) + (self.minutes * 60) + self.seconds
    }
    
    private var calendar: Calendar {
        return Calendar(identifier: .gregorian)
    }
    
    /// Helper that checks if today's week is "every other week"
    /// Every other week are odd weeks of the year
    ///
    /// - Returns: True if today is in an odd week
    var isEveryOtherWeek: Bool {
        let weekOfYear = calendar.component(.weekOfYear, from: self)
        return (weekOfYear % 2) == 1
    }
    
    /// Helper that checks if today's date is "every other day"
    /// Every other days are: Mondays, Wednesdays, Fridays, and Sundays
    /// Weekday units are the numbers 1 through n, where n is the number of days in the week.
    /// For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
    ///
    /// - Returns: True if today is every other day
    var isEveryOtherDay: Bool {
        let day = calendar.component(.weekday, from: self)
        return day == 1 || day == 2 || day == 4 || day == 6
    }
    
    var relative: String {
        let formatter = DateFormatter.getDefaultFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
    
    var relativeWithTime: String {
        let formatter = DateFormatter.getDefaultFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
    
    var components: DateComponents {
        return Calendar.current.dateComponents(in: Calendar.current.timeZone, from: self)
    }
    
    init(y: Int, mo: Int = 1, d: Int = 1,
         h: Int = 0, m: Int = 0, s: Int = 0) {
        var dateComponents = DateComponents()
        dateComponents.year = y
        dateComponents.month = mo
        dateComponents.day = d
        dateComponents.hour = h
        dateComponents.minute = m
        dateComponents.second = s
        self = Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    func weeksFromDate(_ toDate: Date) -> Int? {
        return Calendar.current.dateComponents([.weekOfYear], from: self, to: toDate).weekOfYear
    }
    
    func daysFromDate(_ toDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: self, to: toDate).day
    }
    
    func secondsFromDate(_ toDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: self, to: toDate).second
    }
    
    func monthsFromDate(_ toDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: self, to: toDate).month
    }
    
    func yearsFromDate(_ toDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: self, to: toDate).year
    }
    
    /// - note: Day changes according to device timezone.
    func toString(withFormat format: String, timeZone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: format, timeZone: timeZone)
        return dateFormatter.string(from: self)
    }
    
    func toStringAsUTC(withFormat format: String) -> String {
        return toString(withFormat: format, timeZone: TimeZone(identifier: "UTC"))
    }
    
    func toStringWithDaylightSavingOffset(withFormat format: String) -> String {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: format)
        let offset = dateFormatter.timeZone.daylightSavingTimeOffset(for: Date())
        return dateFormatter.string(from: self + offset)
    }
    
    func getLocalShortDate() -> String {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "MM/dd/yyyy")
        return dateFormatter.string(from: self)
    }
    
    func getLocalShortTime() -> String {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "hh:mm a")
        return dateFormatter.string(from: self)
    }
    
    func getLocalShortTime2() -> String {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "h:mm a")
        return dateFormatter.string(from: self)
    }
    
    func getLocalShortTimeTight() -> String {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "hh:mma")
        return dateFormatter.string(from: self)
    }
    
    func getShortDate(utcOffset: String?) -> String? {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "MM/dd/yyyy", timeZone: TimeZone(abbreviation: utcOffset ?? "GMT+0:00"))
        return dateFormatter.string(from: self)
    }
    
    func getLocalShortDate2() -> String {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "MM/dd")
        return dateFormatter.string(from: self)
    }
    
    func getShortTime(utcOffset: String?) -> String? {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "hh:mm a", timeZone: TimeZone(abbreviation: utcOffset ?? "GMT+0:00"))
        return dateFormatter.string(from: self)
    }
    
    func getTimestamp(utcOffset: String?) -> String? {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSS", timeZone: TimeZone(abbreviation: utcOffset ?? "GMT+0:00"))
        return dateFormatter.string(from: self)
    }
    
    func getLongDateAndTime(utcOffset: String?) -> String? {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "MMM d, yyyy hh:mm a", timeZone: TimeZone(abbreviation: utcOffset ?? "GMT+0:00"))
        return dateFormatter.string(from: self)
    }
    
    func getBirthdateString() -> String? {
        let dateFormatter = DateFormatter.getDefaultFormatter(format: "MMM d, yyyy", timeZone: TimeZone(abbreviation: "GMT+0:00"))
        return dateFormatter.string(from: self)
    }
    
    func getReadingDateStyle() -> String {
        return toString(withFormat: "MMMM d, yyyy • hh:mma")
    }
    
    func getReadingDateShortStyle() -> String {
        return toString(withFormat: "MMMM d, yyyy")
    }
    
    func getDateSimpleStyle() -> String {
        return toString(withFormat: "MMM d, yyyy")
    }
    
    func getDayWithMonthStyle() -> String {
        return toString(withFormat: "MMM d")
    }
}

extension DateFormatter {
    static func getDefaultFormatter(format: String? = nil, timeZone: TimeZone? = nil) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.getDefaultLocale()
        if let format = format {
            dateFormatter.dateFormat = format
        }
        if let timeZone = timeZone {
            dateFormatter.timeZone = timeZone
        }
        return dateFormatter
    }
}

extension Locale {
    static func getDefaultLocale() -> Locale {
        return Locale.current
    }
}
