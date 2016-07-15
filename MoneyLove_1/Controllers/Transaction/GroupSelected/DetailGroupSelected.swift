//
//  DetailGroupSelected.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
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
        self.configureNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureNavigationBar() {
        let leftButton = UIBarButtonItem(title: "B", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailGroupSelected.clickToBack(_:)))
        let searchButton = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailGroupSelected.clickToSearch(_:)))
        let subModeButton = UIBarButtonItem(title: "Change Mode", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailGroupSelected.clickToChangeModeDisplay(_:)))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = searchButton
    }
    
    func clickToBack(sender: UIBarButtonItem) {
        delegate?.doWhenClickBack()
    }
    
    func clickToSearch(sender: UIBarButtonItem) {
        let searchGroupVC = SearchGroupViewController(nibName: "SearchGroupViewController", bundle: nil)
    }
    
    func clickToChangeModeDisplay(sender: UIBarButtonItem) {
        //TODO
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
