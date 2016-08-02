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
    
    func addWalletDefault() {
        let added = NSUserDefaults.standardUserDefaults().boolForKey("addedWalletDefault")
        if !added {
            let context = AppDelegate.shareInstance.managedObjectContext
            let entity = NSEntityDescription.entityForName(Wallet.CLASS_NAME, inManagedObjectContext: context)
            let cashWallet = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Wallet
            cashWallet.name = "Cash"
            cashWallet.imageName = "wallet"
            cashWallet.firstNumber = 0
            let atmWallet = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Wallet
            atmWallet.name = "ATM"
            atmWallet.imageName = "wallet"
            atmWallet.firstNumber = 0
            do {
                try context.save()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "addedWalletDefault")
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
    
    func getMoneyOfCurrentWallet() -> Int64 {
        let currentWallet = self.currentWallet
        var sum: Int64 = 0
        if let setOfTransactions = currentWallet.transaction {
            for transaction in setOfTransactions {
                let trans = transaction as! Transaction
                if let group = trans.group {
                    if group.type {
                        sum += trans.moneyNumber
                    } else {
                        sum -= trans.moneyNumber
                    }
                }
            }
        }
        return sum
    }
    
    func getMoneyOfAllWallets() -> Int64 {
        let fetchRequest = NSFetchRequest(entityName: Wallet.CLASS_NAME)
        var sum: Int64 = 0
        do {
            if let wallets = try manageObjectContext.executeFetchRequest(fetchRequest) as? [Wallet] {
                for  item in wallets {
                    let wallet = item
                    sum += wallet.firstNumber
                }
            }
        } catch {
            let requestError = error as NSError
            print("\(requestError), \(requestError.userInfo)")
        }
        return sum
    }
    
    func getAllWallets() -> [Wallet]? {
        let fetchRequest = NSFetchRequest(entityName: Wallet.CLASS_NAME)
        do {
            if let wallets = try manageObjectContext.executeFetchRequest(fetchRequest) as? [Wallet] {
                return wallets
            }
        } catch {
            let requestError = error as NSError
            print("\(requestError), \(requestError.userInfo)")
        }
        return nil
    }
    
    func getAllGroups(wallet: Wallet!) -> [Group]? {
        let fetchRequest = NSFetchRequest(entityName: Group.CLASS_NAME)
        let predicateWallet = NSPredicate(format: "wallet.name == %@", wallet.name!)
        fetchRequest.predicate = predicateWallet
        do {
            if let groups = try manageObjectContext.executeFetchRequest(fetchRequest) as? [Group] {
                return groups
            }
        } catch {
            let requestError = error as NSError
            print("\(requestError), \(requestError.userInfo)")
        }
        return nil
    }
}
