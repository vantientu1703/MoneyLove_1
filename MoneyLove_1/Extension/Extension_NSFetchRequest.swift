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

enum SortBy {
    case Category
    case Date
}
extension NSFetchRequest {
    class func getFetchRequest(entityName: String, fromDate: NSDate?, toDate: NSDate?, categoryType: CategoryType, wallet: Wallet, sortBy: SortBy) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: Transaction.CLASS_NAME)
        fetchRequest.fetchBatchSize = 20
        let firstSortDescriptor = NSSortDescriptor(key: "group.name", ascending: false)
        let secondSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let arraySortDescriptor:[NSSortDescriptor]
        if sortBy == .Category {
            arraySortDescriptor = [firstSortDescriptor, secondSortDescriptor]
        } else {
            arraySortDescriptor = [secondSortDescriptor]
        }
        fetchRequest.sortDescriptors = arraySortDescriptor
        var predicate:NSPredicate?
        var datePredicate: NSPredicate?
        if fromDate == nil && toDate != nil {
            datePredicate = NSPredicate.predicateToDay(toDate!, ignore: false)
        } else if fromDate != nil && toDate == nil {
            datePredicate = NSPredicate.predicateFromDay(fromDate!, ignore: false)
        }else if fromDate != nil && toDate != nil {
            if fromDate!.isEqualToDate(toDate!) {
                datePredicate = NSPredicate.predicateAtDay(fromDate!)
            } else {
                print("\(fromDate)---\(toDate)")
                datePredicate = NSPredicate.predicateFromADayToOtherDay(fromDate!, end: toDate!, ignoreStartDate: false, ignoreEndDate: false)
            }
        } else {
            datePredicate = nil
        }
        let categoryPredicate = NSPredicate.predicateWithCategoryType(categoryType)
        let walletPredicate = NSPredicate(format: "wallet == %@", wallet)
        if let categoryPre = categoryPredicate {
            if let datePre = datePredicate {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePre, categoryPre, walletPredicate])
            } else {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPre, walletPredicate])
            }
        } else {
            if let datePre = datePredicate {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePre, walletPredicate])
            } else {
                predicate = walletPredicate
            }
        }
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    class func getFetchRequest(entityName: String, fromDate: NSDate?, toDate: NSDate?, categoryType: CategoryType, wallet: Wallet, sortBy: SortBy, groupBy: GroupBy, functionType: FunctionType, resultType: NSFetchRequestResultType) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest.getFetchRequest(entityName, fromDate: fromDate, toDate: toDate, categoryType: categoryType, wallet: wallet, sortBy: sortBy)
        switch functionType {
        case .Sum:
            let sumExpression = NSExpression(format: "sum:(moneyNumber)")
            let sumED = NSExpressionDescription()
            sumED.expression = sumExpression
            sumED.name = "sumOfAmount"
            sumED.expressionResultType = .DoubleAttributeType
            switch groupBy {
            case .MonthAndYear:
                fetchRequest.propertiesToFetch = ["monthString", sumED]
                break
            case .DayMonthYear:
                fetchRequest.propertiesToFetch = ["dayString", sumED]
                break
            default:
                fetchRequest.propertiesToFetch = ["group", sumED]

            }
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
