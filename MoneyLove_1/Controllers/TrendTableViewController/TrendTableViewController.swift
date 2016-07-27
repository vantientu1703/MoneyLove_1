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
    let IDENTIFIER_PIE_CHART_TABLE_CELL = "PieChartCategoryTableViewCell"
    let IDENTIFIER_TREND_TABLE_CELL = "TrendTableViewCell"
    let IDENTIFIER_CATEGORY_TABLE_CELL = "CategoryTableViewCell"
    var currentMonth: Int!
    var currentYear: Int!
    var fromMonth: Int = 1
    var toMonth: Int!
    var fromYear: Int!
    var toYear: Int!
    
    var fromDate: NSDate? {
        didSet {
            if let _ = self.toDate {
                checkRequestData()
            }
        }
    }
    var toDate: NSDate? {
        didSet {
            if let _ = self.toDate {
                checkRequestData()
            }
        }
    }
    
    let context = AppDelegate.shareInstance.managedObjectContext
    var currentCategoryType = CategoryType.Expense
    var currentGroupBy = GroupBy.MonthAndYear
    var isNetIncome = false
    var isByCategory = false
    var dataListExpenseIncome = [[String: AnyObject]]()
    var dataListExpenseIncomeByCategory = [[String: AnyObject]]()
    var subViewPicker: UIView?
    var viewGround: UIView?
    @IBOutlet weak var monthYearPickerView: MonthYearPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: MENU_TITLE, style: UIBarButtonItemStyle.Plain, target: self,
        action: #selector(UIViewController.presentLeftMenuViewController(_:)))
        setupInit()
    }
    
    func setupInit() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TrendTableViewController.doneAction(_:)))
        self.tableView.addGestureRecognizer(tapGesture)
        self.tableView.allowsSelection = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: MENU_TITLE, style: UIBarButtonItemStyle.Plain, target: self,
             action: #selector(TrendTableViewController.presentLeftMenuViewController(_:)))
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
    
    func checkRequestData() {
        if isByCategory {
            requestDataWithCategory()
        } else {
            if isNetIncome {
                requestDataWithNetIncome()
            } else {
                requestDataExpenseIncome()
            }
        }
    }
    
    func requestTransaction(fromDate: NSDate, toDate: NSDate,
         categoryType: CategoryType, wallet: Wallet, groupBy: GroupBy,
         functionType: FunctionType, resultType: NSFetchRequestResultType) -> [AnyObject]?{
        let request = NSFetchRequest.getFetchRequest(Transaction.CLASS_NAME,
                                                     fromDate: fromDate,
                                                     toDate: toDate,
                                                     categoryType: categoryType,
                                                     wallet: wallet,sortBy: SortBy.Date,
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
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_ACTION_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_ACTION_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_BAR_CHART_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_BAR_CHART_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_TREND_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_TREND_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_PIE_CHART_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_PIE_CHART_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_CATEGORY_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_CATEGORY_TABLE_CELL)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUMBER_SECTION
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return NUMBER_ROW_SECTION0
        }
        if isByCategory {
            return dataListExpenseIncomeByCategory.count + 1
        } else {
            return dataListExpenseIncome.count + 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let actionCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_ACTION_TABLE_CELL,
                forIndexPath: indexPath) as! ActionTableViewCell
            self.handlerfilterTrends(actionCell)
            return actionCell
        } else {
            if indexPath.row == 0 {
                if isByCategory {
                    let pieChartCategory = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_PIE_CHART_TABLE_CELL,
                        forIndexPath: indexPath) as! PieChartCategoryTableViewCell
                    pieChartCategory.setDataCharCategory(dataListExpenseIncomeByCategory)
                    return pieChartCategory
                } else {
                    let barChartCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_BAR_CHART_TABLE_CELL,
                        forIndexPath: indexPath) as! BarChartTableViewCell
                    if isNetIncome {
                        barChartCell.setDataDictionaryNetIcome(dataListExpenseIncome)
                    } else {
                        barChartCell.setDataDictionaryExpenseIncome(dataListExpenseIncome,
                        fromDate: fromDate!, toDate: toDate!, currentCategoryType: currentCategoryType)
                    }
                    return barChartCell
                }
            } else {
                if isByCategory {
                    let categoryCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_CATEGORY_TABLE_CELL,
                        forIndexPath: indexPath) as! CategoryTableViewCell
                    let dic = dataListExpenseIncomeByCategory[indexPath.row - 1]
                    categoryCell.setDateCategory(dic)
                    return categoryCell
                } else {
                    let trendCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_TREND_TABLE_CELL,
                        forIndexPath: indexPath) as! TrendTableViewCell
                    if isNetIncome {
                        let dic = dataListExpenseIncome[indexPath.row - 1]
                        trendCell.setDataTrendCellNetIncome(dic)
                    } else {
                        let dic = dataListExpenseIncome[indexPath.row - 1]
                        trendCell.setDataTrendCellDefault(dic, currentCategoryType: currentCategoryType)
                    }
                    return trendCell
                }
            }
        }
    }
    
    //MARK: handlerfilterTrends
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
                    weakSelf.viewGround = UIView(frame: UIScreen.mainScreen().bounds)
                    weakSelf.viewGround!.backgroundColor = UIColor.lightGrayColor()
                    weakSelf.viewGround!.alpha = 0.7
                    weakSelf.view.addSubview(weakSelf.viewGround!)
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
                weakSelf.isByCategory = false
                weakSelf.requestDataExpenseIncome()
                
                break
            case (SegmentGroupType.Expense, SegmentGroupByTrend.Category):
                weakSelf.currentCategoryType = CategoryType.Expense
                weakSelf.isNetIncome = false
                weakSelf.isByCategory = true
                weakSelf.requestDataWithCategory()
                break
            case (SegmentGroupType.Income, SegmentGroupByTrend.OverTime):
                weakSelf.currentCategoryType = CategoryType.Income
                weakSelf.isNetIncome = false
                weakSelf.requestDataExpenseIncome()
                break
            case (SegmentGroupType.Income, SegmentGroupByTrend.Category):
                weakSelf.currentCategoryType = CategoryType.Income
                weakSelf.isByCategory = true
                weakSelf.isNetIncome = false
                weakSelf.requestDataWithCategory()
                break
            default:
                actionCell.segmentGroupBy.selectedSegmentIndex = 0
                weakSelf.isNetIncome = true
                weakSelf.isByCategory = false
                weakSelf.requestDataWithNetIncome()
                break
            }
        }
    }
    
    //MARK: requestDataExpenseIncome
    func requestDataExpenseIncome() {
        let arr = self.requestTransaction(fromDate!, toDate: toDate!, categoryType: currentCategoryType,
            wallet: DataManager.shareInstance.currentWallet, groupBy: currentGroupBy,
            functionType: FunctionType.Sum, resultType: NSFetchRequestResultType.DictionaryResultType)!
        var arrMonths = [String]()
        self.dataListExpenseIncome.removeAll()
        let countMonth = self.toDate!.months(from: self.fromDate!)
        for i in 0...countMonth {
            arrMonths.append(DataPageView.getMonthPage(i, toDate: self.fromDate!).1)
        }
        for month in arrMonths {
            var dict: Dictionary<String, AnyObject> = ["monthString" : month, "expense" : 0.0, "income" : 0.0]
            for item in arr {
                let monthString = item["monthString"] as! String
                if monthString == month {
                    dict["monthString"] = monthString
                    if currentCategoryType == CategoryType.Expense {
                        let expenseValue = item["sumOfAmount"] as! Double
                        dict["expense"] = expenseValue
                    }
                    if currentCategoryType == CategoryType.Income{
                        let incomeValue = item["sumOfAmount"] as! Double
                        dict["income"] = incomeValue
                    }
                }
            }
            self.dataListExpenseIncome.append(dict)
        }
        self.tableView.reloadData()
    }
    
    //MARK: requestDataWithNetIncome
    func requestDataWithNetIncome() {
        let resultsExpense = self.requestTransaction(self.fromDate!, toDate: self.toDate!,
            categoryType: CategoryType.Expense, wallet: DataManager.shareInstance.currentWallet,
            groupBy: GroupBy.MonthAndYear, functionType: FunctionType.Sum,
            resultType: NSFetchRequestResultType.DictionaryResultType)
        let resultsIncome = self.requestTransaction(self.fromDate!, toDate: self.toDate!,
            categoryType: CategoryType.Income, wallet: DataManager.shareInstance.currentWallet,
            groupBy: GroupBy.MonthAndYear, functionType: FunctionType.Sum,
            resultType: NSFetchRequestResultType.DictionaryResultType)
        var arrMonths = [String]()
        self.dataListExpenseIncome.removeAll()
        let countMonth = self.toDate!.months(from: self.fromDate!)
        for i in 0...countMonth {
            arrMonths.append(DataPageView.getMonthPage(i, toDate: self.fromDate!).1)
        }
        
        for month in arrMonths {
            var dict: Dictionary<String, AnyObject> = ["monthString" : month, "expense" : 0.0, "income" : 0.0]
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
            self.dataListExpenseIncome.append(dict)
        }
        self.tableView.reloadData()
    }
    
    //MARK: requestDataWithCategory
    func requestDataWithCategory() {
        dataListExpenseIncomeByCategory.removeAll()
        let results = self.requestTransaction(self.fromDate!, toDate: self.toDate!,
            categoryType: currentCategoryType, wallet: DataManager.shareInstance.currentWallet,
            groupBy: GroupBy.Category, functionType: FunctionType.Sum,
            resultType: NSFetchRequestResultType.DictionaryResultType)
        if let arrGroup = results as? [[String: AnyObject]] {
            var dict = ["totalMoney": 0, "groupName": "", "groupImage": ""]
            for groupItem in arrGroup {
                let groupTotalMoney = groupItem["sumOfAmount"] as! Int
                let groupId = groupItem["group"] as! NSManagedObjectID
                let group = context.objectWithID(groupId) as! Group
                let groupName = group.name
                let groupImage = group.imageName
                dict["totalMoney"] = groupTotalMoney
                dict["groupName"] = groupName
                dict["groupImage"] = groupImage
                dataListExpenseIncomeByCategory.append(dict)
            }
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
        viewGround?.removeFromSuperview()
        subViewPicker?.removeFromSuperview()
    }
}

extension TrendTableViewController: RESideMenuDelegate {
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
}
