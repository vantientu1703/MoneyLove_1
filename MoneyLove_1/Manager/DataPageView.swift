//
//  DataPageView.swift
//  MoneyLove_1
//
//  Created by framgia on 7/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class DataPageView: NSObject {
    static var numberPage = 0

    static func getMonthPage(monthsToAdd: Int, toDate: NSDate) -> (NSDate, String) {
        let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: monthsToAdd, toDate: toDate, options: NSCalendarOptions.init(rawValue: 0))
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        return (calculatedDate!, dateFormatter.stringFromDate(calculatedDate!))
    }
    
    static func getDayPage(daysToAdd: Int, firstDate: NSDate) -> NSDate {
        let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: daysToAdd, toDate: firstDate, options: NSCalendarOptions.init(rawValue: 0))
        return calculatedDate!
    }
    
    static func getWeeksPage(weeksToAdd: Int, firstDate: NSDate) -> (NSDate, NSDate, String) {
        let firstDay = getDayPage(weeksToAdd * 7, firstDate: firstDate)
        let lastDay = getDayPage(6, firstDate: firstDay)
        let newFirstDay = NSDate.startOfDay(firstDay)
        let newLastDay = NSDate.endOfDay(lastDay)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return (newFirstDay,newLastDay,"\(dateFormatter.stringFromDate(newFirstDay)) - \(dateFormatter.stringFromDate(newLastDay))")
    }
}
