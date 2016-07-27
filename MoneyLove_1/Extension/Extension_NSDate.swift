//
//  Extension_NSDate.swift
//  MoneyLove_1
//
//  Created by framgia on 7/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation

extension NSDate {
    
    convenience init(dateString: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:date!)
    }
    
    class func getCurrentMonth() ->Int {
        return NSCalendar(identifier: NSCalendarIdentifierGregorian)!.component(.Month, fromDate: NSDate())
    }
    
    class func getCurrentYear() ->Int {
        return NSCalendar(identifier: NSCalendarIdentifierGregorian)!.component(.Year, fromDate: NSDate())
    }
        
    class func startOfDay(date: NSDate) -> NSDate {
        let startOfDay = NSCalendar.currentCalendar().startOfDayForDate(date)
        return startOfDay
    }
    
    class func endOfDay(date: NSDate) -> NSDate {
        let startOfDay =  NSCalendar.currentCalendar().startOfDayForDate(date)
        let components = NSDateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endOfDay = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions(rawValue: 0))
        return endOfDay!
    }
    class func dayOfTheWeek(date: NSDate) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }

    class func getMonthStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        return dateFormatter.stringFromDate(date)
    }
    // Returns the amount of months from another date
    func months(from date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: []).month ?? 0
    }
    
    func startOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components([.Year, .Month], fromDate: self) else { return nil }
        comp.to12pm()
        return cal.dateFromComponents(comp)!
    }
    
    func endOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = NSDateComponents() else { return nil }
        comp.month = 1
        comp.day -= 1
        comp.to12pm()
        return cal.dateByAddingComponents(comp, toDate: self.startOfMonth()!, options: [])!
    }
    
    class func convertTimeIntervalToDateString(time: NSTimeInterval) -> String {
        let date = NSDate(timeIntervalSinceReferenceDate: time)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.stringFromDate(date)
    }
}

internal extension NSDateComponents {
    func to12pm() {
        self.hour = 12
        self.minute = 0
        self.second = 0
    }
}