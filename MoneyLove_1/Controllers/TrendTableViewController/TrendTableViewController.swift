//
//  TrendTableViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

class TrendTableViewController: UITableViewController {
    
    let HEIGHT_CELL_DEFAULT: CGFloat = 65.0
    let HEIGHT_CELL_ACTION: CGFloat = 220.0
    let HEIGHT_CELL_CHART: CGFloat = 320.0
    let NUMBER_SECTION: Int = 2
    let NUMBER_ROW_SECTION0: Int = 1
    let IDENTIFIER_ACTION_TABLE_CELL = "ActionTableViewCell"
    let IDENTIFIER_BAR_CHART_TABLE_CELL = "BarChartTableViewCell"
    let IDENTIFIER_TREND_TABLE_CELL = "TrendTableViewCell"
    var currentMonth: Int?
    var currentYear: Int?
    var fromMonth: Int = 1
    var toMonth: Int?
    var fromYear: Int?
    var toYear: Int?
    
    var fromDate: NSDate? {
        didSet {
            if let toDate = toDate {
                if isNetIncome {
                    self.requestDataWithNetIncome()
                }else {
                    dataListDefaultCell = self.requestTransaction(fromDate!,
                                                                  toDate: toDate,
                                                                  categoryType: currentCategoryType,
                                                                  wallet: DataManager.shareInstance.currentWallet,
                                                                  groupBy: currentGroupBy,
                                                                  functionType: FunctionType.Sum,
                                                                  resultType: NSFetchRequestResultType.DictionaryResultType)!
                }
                self.tableView.reloadData()
            }
        }
    }
    var toDate: NSDate? {
        didSet {
            if let fromDate = fromDate {
                if isNetIncome {
                    self.requestDataWithNetIncome()
                }else {
                    dataListDefaultCell = self.requestTransaction(fromDate,
                                                                  toDate: toDate!,
                                                                  categoryType: currentCategoryType,
                                                                  wallet: DataManager.shareInstance.currentWallet,
                                                                  groupBy: currentGroupBy,
                                                                  functionType: FunctionType.Sum,
                                                                  resultType: NSFetchRequestResultType.DictionaryResultType)!
                }
                self.tableView.reloadData()
            }
        }
    }
    
    let context = AppDelegate.shareInstance.managedObjectContext
    var currentCategoryType = CategoryType.Expense
    var currentGroupBy = GroupBy.MonthAndYear
    var isNetIncome = false
    var dataListDefaultCell = [AnyObject]()
    var dataListNetIncome = [Dictionary<String, AnyObject>]()
    
    var subViewPicker: UIView?
    @IBOutlet weak var monthYearPickerView: MonthYearPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: MENU_TITLE, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.presentLeftMenuViewController(_:)))
        setupInit()
    }
    
    func setupInit() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TrendTableViewController.doneAction(_:)))
        self.tableView.addGestureRecognizer(tapGesture)
        self.tableView.allowsSelection = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TrendTableViewController.presentLeftMenuViewController(_:)))
        currentMonth = NSDate.getCurrentMonth()
        currentYear = NSDate.getCurrentYear()
        fromYear = currentYear
        toYear = currentYear
        toMonth = currentMonth! + 1
        if fromDate == nil {
            fromDate = NSDate(dateString: "\(fromYear)-\(fromMonth)")
        }
        if toDate == nil {
            toDate = NSDate(dateString: "\(toYear)-\(toMonth)")
        }
    }
    
    func requestTransaction(fromDate: NSDate, toDate: NSDate, categoryType: CategoryType, wallet: Wallet, groupBy: GroupBy, functionType: FunctionType, resultType: NSFetchRequestResultType) -> [AnyObject]?{
        let request = NSFetchRequest.getFetchRequest(Transaction.CLASS_NAME,
                                                     fromDate: fromDate,
                                                     toDate: toDate,
                                                     categoryType: categoryType,
                                                     wallet: wallet,
                                                     groupBy: groupBy,
                                                     functionType: functionType,
                                                     resultType: resultType)
        do {
            let results = try context.executeFetchRequest(request)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
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
        if isNetIncome {
            return dataListNetIncome.count+1
        } else {
            return dataListDefaultCell.count+1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let actionCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_ACTION_TABLE_CELL, forIndexPath: indexPath) as! ActionTableViewCell
            self.handlerfilterTrends(actionCell)
            return actionCell
        } else {
            if indexPath.row == 0 {
                let barChartCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_BAR_CHART_TABLE_CELL, forIndexPath: indexPath) as! BarChartTableViewCell
                if isNetIncome {
                    barChartCell.setDataDictionaryNetIcome(dataListNetIncome)
                } else {
                    barChartCell.setDataDictionaryExpenseIncome(dataListDefaultCell as! [Dictionary<String, NSObject>], fromDate: fromDate!, toDate: toDate!)
                }
                return barChartCell
            } else {
                let trendCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_TREND_TABLE_CELL, forIndexPath: indexPath) as! TrendTableViewCell
                if isNetIncome {
                    let dic = dataListNetIncome[indexPath.row-1]
                    trendCell.setDataTrendCellNetIncome(dic)
                } else {
                    let dic = dataListDefaultCell[indexPath.row-1] as! Dictionary<String, AnyObject>
                    trendCell.setDataTrendCellDefault(dic)
                }
                return trendCell
            }
        }
    }
    
    func handlerfilterTrends(actionCell: ActionTableViewCell) {
        actionCell.btnDateFrom.setTitle("\(fromMonth)/\(fromYear)", forState: UIControlState.Normal)
        actionCell.btnDateTo.setTitle("\(toMonth)/\(toYear)", forState: UIControlState.Normal)
        actionCell.handlerSelectDate = { [weak self] (date: SelectDate) -> () in
            guard let weakSelf = self else {return}
            dispatch_async(dispatch_get_main_queue(), {
                if let customView = NSBundle.mainBundle().loadNibNamed("DatePickerView", owner: self, options: nil).first as? UIView {
                    weakSelf.subViewPicker = customView
                    weakSelf.subViewPicker!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
                    weakSelf.subViewPicker!.center = weakSelf.view.center
                    weakSelf.view.addSubview(weakSelf.subViewPicker!)
                    weakSelf.monthYearPickerView.onDateSelected = { (nameMonth: String, indexMonth: Int, year: Int) in
                        switch date {
                        case .FromDate:
                            let dateTmp = NSDate(dateString: "\(year)-\(indexMonth)")
                            let monthTmp = dateTmp.months(from: weakSelf.toDate!)
                            if monthTmp < 0 {
                                actionCell.btnDateFrom.setTitle("\(indexMonth)/\(year)", forState: .Normal)
                                weakSelf.fromMonth = indexMonth
                                weakSelf.fromYear = year
                                weakSelf.fromDate = dateTmp
                            }
                            break
                        case .ToDate:
                            let dateTmp = NSDate(dateString: "\(year)-\(indexMonth)")
                            let monthTmp = dateTmp.months(from: weakSelf.fromDate!)
                            if monthTmp > 0 {
                                actionCell.btnDateTo.setTitle("\(indexMonth)/\(year)", forState: .Normal)
                                weakSelf.toMonth = indexMonth
                                weakSelf.toYear = year
                                weakSelf.toDate = dateTmp
                            }
                            break
                        }
                    }
                }
            })
        }
        
        actionCell.handerSelectSegment = { [weak self] (groupType: SegmentGroupType, groupByTrend: SegmentGroupByTrend) -> () in
            guard let weakSelf = self else { return }
            switch (groupType, groupByTrend) {
            case (SegmentGroupType.Expense, SegmentGroupByTrend.OverTime):
                weakSelf.currentCategoryType = CategoryType.Expense
                weakSelf.isNetIncome = false
                let results = weakSelf.requestTransaction(weakSelf.fromDate!,
                                                            toDate: weakSelf.toDate!,
                                                            categoryType: CategoryType.Expense,
                                                            wallet: DataManager.shareInstance.currentWallet,
                                                            groupBy: GroupBy.MonthAndYear,
                                                            functionType: FunctionType.Sum,
                                                            resultType: NSFetchRequestResultType.DictionaryResultType)
                if let resultsList = results as? [Dictionary<String, AnyObject>] {
                    weakSelf.dataListDefaultCell = resultsList
                    weakSelf.tableView.reloadData()
                }
                break
            case (SegmentGroupType.Expense, SegmentGroupByTrend.Category):
                weakSelf.isNetIncome = false
                break
            case (SegmentGroupType.Income, SegmentGroupByTrend.OverTime):
                weakSelf.currentCategoryType = CategoryType.Income
                weakSelf.isNetIncome = false
                let results = weakSelf.requestTransaction(weakSelf.fromDate!,
                                                            toDate: weakSelf.toDate!,
                                                            categoryType: CategoryType.Income,
                                                            wallet: DataManager.shareInstance.currentWallet,
                                                            groupBy: GroupBy.MonthAndYear,
                                                            functionType: FunctionType.Sum,
                                                            resultType: NSFetchRequestResultType.DictionaryResultType)
                if let resultsList = results as? [Dictionary<String, AnyObject>] {
                    weakSelf.dataListDefaultCell = resultsList
                    weakSelf.tableView.reloadData()
                }
                break
            case (SegmentGroupType.Income, SegmentGroupByTrend.Category):
                weakSelf.isNetIncome = false
                break
            default:
                actionCell.segmentGroupBy.selectedSegmentIndex = 0
                weakSelf.isNetIncome = true
                weakSelf.requestDataWithNetIncome()
                break
            }
        }
    }
    
    func requestDataWithNetIncome() {
        let resultsExpense = self.requestTransaction(self.fromDate!,
                                                           toDate: self.toDate!,
                                                           categoryType: CategoryType.Expense,
                                                           wallet: DataManager.shareInstance.currentWallet,
                                                           groupBy: GroupBy.MonthAndYear,
                                                           functionType: FunctionType.Sum,
                                                           resultType: NSFetchRequestResultType.DictionaryResultType)
        let resultsIncome = self.requestTransaction(self.fromDate!,
                                                          toDate: self.toDate!,
                                                          categoryType: CategoryType.Income,
                                                          wallet: DataManager.shareInstance.currentWallet,
                                                          groupBy: GroupBy.MonthAndYear,
                                                          functionType: FunctionType.Sum,
                                                          resultType: NSFetchRequestResultType.DictionaryResultType)
        var arrMonths = [String]()
        self.dataListNetIncome.removeAll()
        let countMonth = self.toDate!.months(from: self.fromDate!)
        for i in 0...countMonth {
            arrMonths.append(DataPageView.getMonthPage(i, toDate: self.fromDate!).1)
        }
        
        for month in arrMonths {
            var dict:Dictionary<String, AnyObject> = ["monthString" : month, "expense" : 0.0, "income" : 0.0]
            for expense in resultsExpense! {
                let monthString = expense["monthString"] as! String
                let expenseValue = expense["sumOfAmount"] as! Double
                if monthString == month {
                    dict["monthString"] = monthString
                    dict["expense"] = expenseValue
                }
            }
            for income in resultsIncome! {
                let monthString = income["monthString"] as! String
                let incomeValue = income["sumOfAmount"] as! Double
                if monthString == month {
                    dict["monthString"] = monthString
                    dict["income"] = incomeValue
                }
            }
            self.dataListNetIncome.append(dict)
        }
        self.tableView.reloadData()
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
        subViewPicker?.removeFromSuperview()
    }
}

extension TrendTableViewController: RESideMenuDelegate {
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
}
