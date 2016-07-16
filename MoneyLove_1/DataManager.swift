//
//  DataManager.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    class var shareInstance: DataManager {
        struct Singleton{
            static let instance = DataManager()
        }
        return Singleton.instance
    }
    var manageObjectContext: NSManagedObjectContext
    init() {
        manageObjectContext = AppDelegate().managedObjectContext
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
}