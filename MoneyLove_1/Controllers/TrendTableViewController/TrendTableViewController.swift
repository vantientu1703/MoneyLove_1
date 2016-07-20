//
//  TrendTableViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class TrendTableViewController: UITableViewController {
    
    let HEIGHT_CELL_DEFAULT: CGFloat = 65
    let HEIGHT_CELL_ACTION: CGFloat = 220
    let HEIGHT_CELL_CHART: CGFloat = 320
    let NUMBER_SECTION: Int = 2
    let NUMBER_ROW_SECTION0: Int = 1
    let NUMBER_ROW_SECTION1: Int = 13
    let IDENTIFIER_ACTION_TABLE_CELL = "ActionTableViewCell"
    let IDENTIFIER_BAR_CHART_TABLE_CELL = "BarChartTableViewCell"
    let IDENTIFIER_TREND_TABLE_CELL = "TrendTableViewCell"
    let arrMonths = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    @IBOutlet var subViewPicker: UIView!
    @IBOutlet weak var monthYearPickerView: MonthYearPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.presentLeftMenuViewController(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCell() {
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_ACTION_TABLE_CELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_ACTION_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_BAR_CHART_TABLE_CELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_BAR_CHART_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_TREND_TABLE_CELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_TREND_TABLE_CELL)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUMBER_SECTION
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return NUMBER_ROW_SECTION0
        }
        return NUMBER_ROW_SECTION1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let actionCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_ACTION_TABLE_CELL, forIndexPath: indexPath) as! ActionTableViewCell
            actionCell.actionHandler = { [weak self] (name: String) -> () in
                NSBundle.mainBundle().loadNibNamed("DatePickerView", owner: self, options: nil)
                self!.subViewPicker.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
                self!.subViewPicker.center = self!.view.center
                self!.view.addSubview(self!.subViewPicker)
                self!.monthYearPickerView.onDateSelected = { (nameMonth: String, year: Int) in
                    if name == "From" {
                        actionCell.btnDateFrom.setTitle("\(nameMonth)  \(year)", forState: .Normal)
                        //TODO
                    } else {
                        actionCell.btnDateTo.setTitle("\(nameMonth)  \(year)", forState: .Normal)
                        //TODO
                    }
                }
            }
            return actionCell
        } else {
            if indexPath.row == 0 {
                let barChartCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_BAR_CHART_TABLE_CELL, forIndexPath: indexPath) as! BarChartTableViewCell
                barChartCell.setupDataChart()
                return barChartCell
            } else {
                let trendCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_TREND_TABLE_CELL, forIndexPath: indexPath) as! TrendTableViewCell
                trendCell.setDataTrendCell(arrMonths[indexPath.row - 1], money: 0)
                return trendCell
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HEIGHT_CELL_ACTION;
        } else {
            if indexPath.row == 0 {
                return HEIGHT_CELL_CHART
            }
            return HEIGHT_CELL_DEFAULT
        }
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        subViewPicker.removeFromSuperview()
    }
}

extension TrendTableViewController: RESideMenuDelegate {
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
}
