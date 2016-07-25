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
        let predicate = NSPredicate(format: expression, NSDate.startOfDay(date))
        return predicate
    }
    
    class func predicateToDay(date: NSDate, ignore: Bool) -> NSPredicate {
        let operatorString = ignore ? " < " : " <= "
        let expression = Transaction.DATE_VARIABLE_NAME + operatorString + "%@"
        let predicate = NSPredicate(format: expression,  NSDate.endOfDay(date))
        return predicate
    }
    
    class func predicateFromADayToOtherDay(start: NSDate, end: NSDate, ignoreStartDate: Bool, ignoreEndDate: Bool) -> NSPredicate {
        let startOperatorString = ignoreStartDate ? " > " : " >= "
        let startExpression = Transaction.DATE_VARIABLE_NAME + startOperatorString + "%@"
        let endOperatorString = ignoreEndDate ? " < " : " <= "
        let endExpression = Transaction.DATE_VARIABLE_NAME + endOperatorString + "%@"
        let sumExpression = startExpression + " AND " + endExpression
        let predicate = NSPredicate(format: sumExpression, NSDate.startOfDay(start), NSDate.endOfDay(end))
        return predicate
    }
    
    class func predicateAtDay(date: NSDate) -> NSPredicate {
        let startOfDay = NSDate.startOfDay(date)
        let endOfDay = NSDate.endOfDay(date)
        let predicate = NSPredicate.predicateFromADayToOtherDay(startOfDay, end: endOfDay, ignoreStartDate: false, ignoreEndDate: false)
        return predicate
    }
    
    class func predicateWithCategoryType(categoryType: CategoryType) -> NSPredicate?{
        var predicate:NSPredicate? = nil
        switch categoryType {
        case .Expense:
            predicate = NSPredicate(format: "group.type == false", argumentArray: nil)
            break
        case .Income:
            predicate = NSPredicate(format: "group.type == true", argumentArray: nil)
            break
        default:
            break
        }
        return predicate
    }
    
    class func predicateWithDebtOrLoanTransaction(isDebt: Bool) -> NSPredicate {
        let stringToFetch = isDebt ? "Debt" : "Loan"
        let predicate = NSPredicate(format: "group.name == %@", stringToFetch)
        return predicate
    }
}