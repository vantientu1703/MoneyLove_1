//
//  PayReceiavableTableViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import TabPageViewController

class PayReceiavableTableViewController: UITableViewController {
    
    let IDENTIFIER_CELL_PAY_RECEIAVABLE = "PayReceiavableTableViewCell"
    let arr = ["A","B","C","D","E"]
    var color: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationHeight = navigationController?.navigationBar.frame.maxY ?? 0.0
        tableView.contentInset.top = navigationHeight + TabPageOption().tabHeight
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_CELL_PAY_RECEIAVABLE, bundle: nil), forCellReuseIdentifier: IDENTIFIER_CELL_PAY_RECEIAVABLE)
    }
    
    override func viewWillAppear(animated: Bool) {
        //TODO
        //reload data
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
        return arr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_CELL_PAY_RECEIAVABLE, forIndexPath: indexPath) as! PayReceiavableTableViewCell
        cell.nameDebts.text = "\(arr[indexPath.row])"
        cell.numberTransaction.text = "1 Transaction"
        cell.totalDebts.text = "\(indexPath.row)"
        if (color != nil) {
            cell.totalDebts.textColor = color
        }
        return cell
    }
}
