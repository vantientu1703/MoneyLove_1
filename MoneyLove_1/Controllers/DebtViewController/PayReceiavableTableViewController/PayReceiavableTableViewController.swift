//
//  PayReceiavableTableViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import TabPageViewController
import CoreData

class PayReceiavableTableViewController: UITableViewController {
    
    let IDENTIFIER_CELL_PAY_RECEIAVABLE = "PayReceiavableTableViewCell"
    var arrTranSaction = [Transaction]()
    var color: UIColor!
    var isDebt = false
    let context = AppDelegate.shareInstance.managedObjectContext
    let HEIGHT_CELL: CGFloat = 70.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationHeight = navigationController?.navigationBar.frame.maxY ?? 0.0
        tableView.contentInset.top = navigationHeight + TabPageOption().tabHeight
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_CELL_PAY_RECEIAVABLE, bundle: nil), forCellReuseIdentifier: IDENTIFIER_CELL_PAY_RECEIAVABLE)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PayReceiavableTableViewController.changeWallet(_:)), name: "changeWallet", object: nil)
    }
    
    func changeWallet(notifi: NSNotification) {
        requestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "changeWallet", object: nil)
    }
    
    func requestData() {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let arraySortDescriptor = [sortDescriptor]
        let request = NSFetchRequest(entityName: Transaction.CLASS_NAME)
        let predicateChangeWallet = NSPredicate(format: "wallet == %@", DataManager.shareInstance.currentWallet)
        request.sortDescriptors = arraySortDescriptor
        var compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateChangeWallet,
            NSPredicate.predicateWithDebtOrLoanTransaction(true)])
        if isDebt {
            request.predicate = compoundPredicate
            do {
                if let arrTransaction = try context.executeFetchRequest(request) as? [Transaction] {
                    arrTranSaction = arrTransaction
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        } else {
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateChangeWallet,
                NSPredicate.predicateWithDebtOrLoanTransaction(false)])
            request.predicate = compoundPredicate
            do {
                if let arrTransaction = try context.executeFetchRequest(request) as? [Transaction] {
                    arrTranSaction = arrTransaction
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrTranSaction.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_CELL_PAY_RECEIAVABLE, forIndexPath: indexPath) as! PayReceiavableTableViewCell
        let tran = arrTranSaction[indexPath.row]
        cell.setDataPayReceiavableCell(tran, color: color)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL
    }
}
