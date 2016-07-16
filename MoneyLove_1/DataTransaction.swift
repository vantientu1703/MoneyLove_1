//
//  DataTransaction.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class DataTransaction : NSObject {
    var fetchedResultsController: NSFetchedResultsController
    var managedObjectContext: NSManagedObjectContext
    var fetchRequest: NSFetchRequest?
    var startDate: NSDate?
    var endDate: NSDate?
    init(frc: NSFetchedResultsController, managedObjectContext: NSManagedObjectContext) {
        fetchedResultsController = frc
        self.managedObjectContext = managedObjectContext
        super.init()
    }
    
    func getSumOfAllExpenseAndIncome () -> (Double,  Double) {
        let results = fetchedResultsController.fetchedObjects
        var sumExpense = 0.0
        var sumIncome = 0.0
        if let myResults = results {
            for item in myResults {
                let trans = item as! Transaction
                if let group = trans.group {
                    if group.type {
                        sumIncome += trans.moneyNumber
                    } else {
                        sumExpense += trans.moneyNumber
                    }
                }
            }
        }
        return (sumExpense, sumIncome)
    }
    
    func getSumOfAllMoneyInIndexPath(section: Int) -> Double {
        print("Group:")
        if let sections = fetchedResultsController.sections {
            if sections.count > 0 {
                let group = sections[section]
                let resultsInSection = group.objects
                var sum = 0.0
                if let results = resultsInSection {
                    for item in results {
                        let trans = item as! Transaction
                        if let group = trans.group {
                            print("\(group.type) --- \(trans.moneyNumber) ---- \(trans.group?.name)")
                            if group.type {
                                sum += trans.moneyNumber
                            } else {
                                sum -= trans.moneyNumber
                            }
                        }
                    }
                    return sum
                }
            }
        }
        return 0
    }
    
    func getHeaderTitleInIndexPath(section: Int) -> String {
        if let sections = fetchedResultsController.sections {
            if sections.count > 0 {
                let group = sections[section]
                let title = group.name
                return title
            }
        }
        return ""
    }
    
    func getMoneyNumberInIndexPath(indexPath: NSIndexPath) -> Double {
        let result = fetchedResultsController.objectAtIndexPath(indexPath) as! Transaction
        let money = result.moneyNumber
        return money
    }
    
    func getCategoryNameForTransaction(indexPath: NSIndexPath) -> String {
        let result = fetchedResultsController.objectAtIndexPath(indexPath) as! Transaction
        if let group = result.group {
            let categoryName = group.name
            return categoryName!
        }
        return "Category Name"
    }
    
    
    func getCategoryTypeInIndexPath(indexPath: NSIndexPath) -> Bool? {
        let result = fetchedResultsController.objectAtIndexPath(indexPath) as! Transaction
        if let group = result.group {
            let categoryType = group.type
            return categoryType
        }
        return nil
    }
    
    func getTimeForTransaction(indexPath: NSIndexPath) -> String {
        let result = fetchedResultsController.objectAtIndexPath(indexPath) as! Transaction
        let dayString = result.dayString
        return dayString!
    }
    
    func getCategoryImageNameForTransaction(indexPath: NSIndexPath) -> String {
        let result = fetchedResultsController.objectAtIndexPath(indexPath) as! Transaction
        if let group = result.group {
            let categoryImageName = group.imageName
            return categoryImageName!
        }
        
        return ""
    }
    
}