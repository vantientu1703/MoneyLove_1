//
//  DataManager.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation
import CoreData

enum ChangeTransactionType {
    case Insert
    case Remove
    case Move
}

class DataManager : NSObject {
    class var shareInstance: DataManager {
        struct Singleton{
            static let instance = DataManager()
        }
        return Singleton.instance
    }
    var manageObjectContext: NSManagedObjectContext
    var currentWallet: Wallet! {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("changeWallet", object: nil)
        }
    }
    var numberOfWallet: Int!
    override init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        manageObjectContext = appDelegate.managedObjectContext
        super.init()
    }
    //MARK: Wallet
    func addNewWallet(fetchedResultsController: NSFetchedResultsController) -> Wallet? {
        let context = fetchedResultsController.managedObjectContext
        let entity = NSEntityDescription.entityForName(Wallet.CLASS_NAME, inManagedObjectContext: context)
        let wallet = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Wallet
        
        do {
            try context.save()
            return wallet
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return nil
    }
    
    func removeWallet(walletRemoved: Wallet, fetchedResultsController: NSFetchedResultsController) {
        let context = fetchedResultsController.managedObjectContext
        context.deleteObject(walletRemoved)
        do {
            try context.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    //Mark: Group
    func addNewGroup(fetchedResultsController: NSFetchedResultsController) -> Group? {
        let context = fetchedResultsController.managedObjectContext
        let entity = NSEntityDescription.entityForName(Group.CLASS_NAME, inManagedObjectContext: context)
        let group = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Group
        
        do {
            try context.save()
            return group
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return nil
    }
    
    func removeGroup(groupRemoved: Group, fetchedResultsController: NSFetchedResultsController) {
        let context = fetchedResultsController.managedObjectContext
        context.deleteObject(groupRemoved)
        do {
            try context.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    //MARK: Transaction
    func addNewTransaction(fetchedResultController: NSFetchedResultsController) -> Transaction? {
        let context = fetchedResultController.managedObjectContext
        let entity = NSEntityDescription.entityForName(Transaction.CLASS_NAME, inManagedObjectContext: context)
        let trans = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Transaction
        do {
            try context.save()
            return trans
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return nil
    }
    
    func removeTrans(transRemoved: Transaction, fetchedResultsController: NSFetchedResultsController) {
        let context = fetchedResultsController.managedObjectContext
        context.deleteObject(transRemoved)
        do {
            try context.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    func saveManagedObjectContext() {
        do {
            try manageObjectContext.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            abort()
        }
    }
    
    func addCategoriesDefault() {
        let added = NSUserDefaults.standardUserDefaults().boolForKey("addedCategoriesDefault")
        if !added {
            let context = AppDelegate.shareInstance.managedObjectContext
            let entity = NSEntityDescription.entityForName(Group.CLASS_NAME, inManagedObjectContext: context)
            let loanCategory = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Group
            loanCategory.name = "Loan"
            loanCategory.type = false
            loanCategory.imageName = ""
            loanCategory.subType = 2
            let debtCategory = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Group
            debtCategory.name = "Debt"
            debtCategory.type = true
            debtCategory.imageName = ""
            debtCategory.subType = 2
            do {
                try context.save()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "addedCategoriesDefault")
            } catch {
                let saveError = error as NSError
                print("\(saveError), \(saveError.userInfo)")
            }
        }
    }
    
    func addWalletDefault() {
        let added = NSUserDefaults.standardUserDefaults().boolForKey("addedWalletDefault")
        if !added {
            let context = AppDelegate.shareInstance.managedObjectContext
            let entity = NSEntityDescription.entityForName(Wallet.CLASS_NAME, inManagedObjectContext: context)
            let cashWallet = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Wallet
            cashWallet.name = "Cash"
            cashWallet.imageName = ""
            cashWallet.firstNumber = 0
            let atmWallet = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Wallet
            atmWallet.name = "ATM"
            atmWallet.imageName = ""
            atmWallet.firstNumber = 0
            do {
                try context.save()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "addedWalletDefault")
                let categoriesDefault = self.getCategoriesDefaults()
                cashWallet.group = NSSet(array: categoriesDefault)
                atmWallet.group = NSSet(array: categoriesDefault)
            } catch {
                let saveError = error as NSError
                print("\(saveError), \(saveError.userInfo)")
            }
        }
    }
    
    func getCategoriesDefaults() -> [Group] {
        let fetchRequest = NSFetchRequest(entityName: Group.CLASS_NAME)
        do {
            let categoriesDefault = try manageObjectContext.executeFetchRequest(fetchRequest)
            return categoriesDefault as! [Group]
        } catch {
            let requestError = error as NSError
            print("\(requestError), \(requestError.userInfo)")
        }
        return [Group]()
    }
    
    func getWalletDefault() -> Wallet? {
        let fetchRequest = NSFetchRequest(entityName: Wallet.CLASS_NAME)
        do {
            let walletsDefault = try manageObjectContext.executeFetchRequest(fetchRequest)
            return walletsDefault[0] as? Wallet
        } catch {
            let requestError = error as NSError
            print("\(requestError), \(requestError.userInfo)")
        }
        return nil
    }
    
}