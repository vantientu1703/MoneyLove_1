//
//  AllTransactionViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/13/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

class AllTransactionViewController: UIViewController, RESideMenuDelegate {
    let CACHE_NAME = "MONEY_LOVER_CACHE"
    var managedObjectContext:NSManagedObjectContext!
    lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchedRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(Transaction.CLASS_NAME, inManagedObjectContext: self.managedObjectContext)
        fetchedRequest.entity = entity
        fetchedRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "note", ascending: false)
        let arraySortDescriptor = [sortDescriptor]
        fetchedRequest.sortDescriptors = arraySortDescriptor
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        return aFetchedResultsController
    }()
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AllTransactionViewController.presentLeftMenuViewController(_:)))
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickToAddTrans(sender: AnyObject) {
        if let newTrans = DataManager.shareInstance.addNewTransaction(fetchedResultController) {
            let transVC =  TransactionViewController(nibName: "TransactionViewController", bundle: nil)
            transVC.delegate = self
            transVC.managedTransactionObject = newTrans
            navigationController?.pushViewController(transVC, animated: true)
        } else {
            print("Unable to add new transaction")
        }
    }
}

extension AllTransactionViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        myTableView.endUpdates()
    }
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        myTableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let newIndexPath = newIndexPath {
                myTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                myTableView.rectForRowAtIndexPath(indexPath)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            if let newIndexPath = newIndexPath {
                myTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
}

extension AllTransactionViewController: TransactionViewControllerDelegate {
    func delegateDoWhenCancel() {
        dispatch_async(dispatch_get_main_queue()) {
            self.myTableView.reloadData()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func delegateDoWhenDeleteTrans(transRemoved: Transaction, indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue()) { 
            DataManager.shareInstance.removeTrans(transRemoved, fetchedResultsController: self.fetchedResultController)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}

extension AllTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if  cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        let trans = self.fetchedResultController.objectAtIndexPath(indexPath) as! Transaction
        cell!.textLabel!.text = trans.note
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transVC =  TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        transVC.delegate = self
        transVC.managedTransactionObject = self.fetchedResultController.objectAtIndexPath(indexPath) as! Transaction
        transVC.indexPath = indexPath
        transVC.isNewTransaction = false
        navigationController?.pushViewController(transVC, animated: true)
    }
}
