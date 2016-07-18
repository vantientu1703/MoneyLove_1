//
//  Extension_NSFetchRequest.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation
import CoreData

enum GroupBy {
    case MonthAndYear
    case DayMonthYear
    case Category
}

enum CategoryType {
    case Expense
    case Income
    case All
}

enum FunctionType {
    case Sum
    case Max
}
extension NSFetchRequest {
    class func getFetchRequest(entityName: String, fromDate: NSDate?, toDate: NSDate?, categoryType: CategoryType) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: Transaction.CLASS_NAME)
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let arraySortDescriptor = [sortDescriptor]
        fetchRequest.sortDescriptors = arraySortDescriptor
        var predicate:NSPredicate?
        var datePredicate: NSPredicate?
        if fromDate == nil && toDate != nil {
            datePredicate = NSPredicate.predicateToDay(toDate!, ignore: false)
        } else if fromDate != nil && toDate == nil {
            datePredicate = NSPredicate.predicateFromDay(fromDate!, ignore: false)
        }else if fromDate != nil && toDate != nil {
            datePredicate = NSPredicate.predicateFromADayToOtherDay(fromDate!, end: toDate!, ignoreStartDate: false, ignoreEndDate: false)
        } else {
            datePredicate = nil
        }
        let categoryPredicate = NSPredicate.predicateWithCategoryType(categoryType)
        if let categoryPre = categoryPredicate {
            if let datePre = datePredicate {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePre, categoryPre])
            } else {
                predicate = categoryPre
            }
        } else {
            if let datePre = datePredicate {
                predicate = datePre
            } else {
                predicate = nil
            }
        }
        fetchRequest.predicate = nil
        return fetchRequest
    }
    
    class func getFetchRequest(entityName: String, fromDate: NSDate?, toDate: NSDate?, categoryType: CategoryType, groupBy: GroupBy, functionType: FunctionType, resultType: NSFetchRequestResultType) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest.getFetchRequest(entityName, fromDate: fromDate, toDate: toDate, categoryType: categoryType)
        switch functionType {
        case .Sum:
            let sumExpression = NSExpression(format: "sum:(moneyNumber)")
            let sumED = NSExpressionDescription()
            sumED.expression = sumExpression
            sumED.name = "sumOfAmount"
            sumED.expressionResultType = .DoubleAttributeType
            fetchRequest.propertiesToFetch = ["dayString", sumED]
            break
        case .Max:
            let sumExpression = NSExpression(format: "max:(moneyNumber)")
            let sumED = NSExpressionDescription()
            sumED.expression = sumExpression
            sumED.name = "maxOfAmount"
            sumED.expressionResultType = .DoubleAttributeType
            fetchRequest.propertiesToFetch = ["dayString", sumED]
            break
        }
        switch groupBy {
        case .MonthAndYear:
            fetchRequest.propertiesToGroupBy = ["monthString"]
            break
        case .DayMonthYear:
            fetchRequest.propertiesToGroupBy = ["dayString"]
        default:
            fetchRequest.propertiesToGroupBy = ["group.name"]
        }
        fetchRequest.resultType = resultType
        return fetchRequest
    }
}