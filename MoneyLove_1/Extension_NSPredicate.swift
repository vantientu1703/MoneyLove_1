//
//  Extension_NSFetchRequest.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation
import CoreData
extension NSPredicate {
    class func predicateFromDay(date: NSDate, ignore: Bool) -> NSPredicate {
        let operatorString = ignore ? " > " : " >= "
        let expression = Transaction.DATE_VARIABLE_NAME + operatorString + "%@"
        print(expression)
        let predicate = NSPredicate(format: expression, date)
        return predicate
    }
    
    class func predicateToDay(date: NSDate, ignore: Bool) -> NSPredicate {
        let operatorString = ignore ? " < " : " <= "
        let expression = Transaction.DATE_VARIABLE_NAME + operatorString + "%@"
        print(expression)
        let predicate = NSPredicate(format: expression,  date)
        return predicate
    }
    
    class func predicateFromADayToOtherDay(start: NSDate, end: NSDate, ignoreStartDate: Bool, ignoreEndDate: Bool) -> NSPredicate {
        let startOperatorString = ignoreStartDate ? " > " : " >= "
        let startExpression = Transaction.DATE_VARIABLE_NAME + startOperatorString + "%@"
        let endOperatorString = ignoreEndDate ? " < " : " <= "
        let endExpression = Transaction.DATE_VARIABLE_NAME + endOperatorString + "%@"
        let sumExpression = startExpression + " AND " + endExpression
        print(sumExpression)
        let predicate = NSPredicate(format: sumExpression, start, end)
        return predicate
    }
    
    class func predicateWithCategoryType(categoryType: CategoryType) -> NSPredicate?{
        var predicate:NSPredicate? = nil
        switch categoryType {
        case .Expense:
            predicate = NSPredicate(format: "group.type == true", argumentArray: nil)
            break
        case .Income:
            predicate = NSPredicate(format: "group.type == false", argumentArray: nil)
            break
        default:
            break
        }
        return predicate
    }
}