//
//  MonthlyReportViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class ItemReportViewController: UIViewController {
    
    let HEIGHT_CELL_BALANCE: CGFloat = 100.0
    let HEIGHT_CELL_PIECHART: CGFloat = 350.0
    let HEIGHT_CELL_DEFAULT: CGFloat = 65.0
    let HEIGHT_HEADER: CGFloat = 40.0

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.tableView.allowsSelection = false
        monthLabel.text = "\(DataPageView.getMonthPage(pageIndex, toDate: NSDate()))"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCell() {
        self.tableView.registerClass(BalanceTableViewCell.classForCoder(), forCellReuseIdentifier: "BalanceTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "BalanceTableViewCell", bundle: nil), forCellReuseIdentifier: "BalanceTableViewCell")
        
        self.tableView.registerClass(ItemReportTableViewCell.classForCoder(), forCellReuseIdentifier: "ItemReportTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "ItemReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemReportTableViewCell")
        
        self.tableView.registerClass(NetIcomeTableViewCell.classForCoder(), forCellReuseIdentifier: "NetIcomeTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "NetIcomeTableViewCell", bundle: nil), forCellReuseIdentifier: "NetIcomeTableViewCell")
        
        self.tableView.registerClass(PieChartTableViewCell.classForCoder(), forCellReuseIdentifier: "PieChartTableViewCell")
        self.tableView.registerNib(UINib.init(nibName: "PieChartTableViewCell", bundle: nil), forCellReuseIdentifier: "PieChartTableViewCell")
        
    }

}

extension ItemReportViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 4,5:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let balanceCell = tableView.dequeueReusableCellWithIdentifier("BalanceTableViewCell", forIndexPath: indexPath) as! BalanceTableViewCell
            return balanceCell
        } else if indexPath.section == 1 {
            let netIcomeCell = tableView.dequeueReusableCellWithIdentifier("NetIcomeTableViewCell", forIndexPath: indexPath) as! NetIcomeTableViewCell
            return netIcomeCell
        } else if indexPath.section == 2 {
            let itemReportCell = tableView.dequeueReusableCellWithIdentifier("ItemReportTableViewCell", forIndexPath: indexPath) as! ItemReportTableViewCell
            return itemReportCell
        } else if indexPath.section == 3 {
            let expenseCell = tableView.dequeueReusableCellWithIdentifier("PieChartTableViewCell", forIndexPath: indexPath) as! PieChartTableViewCell
            expenseCell.setupDataPieChart()
            return expenseCell
        } else if indexPath.section == 4 {
            let incomeCell = tableView.dequeueReusableCellWithIdentifier("PieChartTableViewCell", forIndexPath: indexPath) as! PieChartTableViewCell
            incomeCell.setupDataPieChart()
            return incomeCell
        } else {
            let itemReportCell = tableView.dequeueReusableCellWithIdentifier("ItemReportTableViewCell", forIndexPath: indexPath) as! ItemReportTableViewCell
            return itemReportCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HEIGHT_CELL_BALANCE
        } else if (indexPath.section == 3 || indexPath.section == 4){
            return HEIGHT_CELL_PIECHART
        } else {
            return HEIGHT_CELL_DEFAULT
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_HEADER
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "BIGGEST EXPENSE"
        } else {
            return ""
        }
    }
}
