//
//  DetailGroupSelected.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import TabPageViewController

enum TypeCategory {
    case LoanAndDebt
    case Expense
    case Income
}
protocol DetailGroupDelegate {
    func doWhenClickBack()
    func doWhenSelectedRow()
}

let HEIGHT_CELL :CGFloat = 50

class DetailGroupSelected: UIViewController {
    var typeCategory = TypeCategory.Expense
    var delegate: DetailGroupDelegate?
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension DetailGroupSelected: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO
    }
}
