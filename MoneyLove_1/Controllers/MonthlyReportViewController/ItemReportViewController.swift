//
//  MonthlyReportViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

enum NameSection: Int {
    case Balance
    case NetIncome
    case BigExpense
    case Expense
    case Income
    case Debt
    case Loan
}

class ItemReportViewController: UIViewController {
    
    let HEIGHT_CELL_BALANCE: CGFloat = 100.0
    let HEIGHT_CELL_PIECHART: CGFloat = 350.0
    let HEIGHT_CELL_DEFAULT: CGFloat = 65.0
    let HEIGHT_HEADER: CGFloat = 40.0
    let IDENTIFIER_BALANCE_TABLE_CELL = "BalanceTableViewCell"
    let IDENTIFIER_ITEM_REPORT_TABLE_CELL = "ItemReportTableViewCell"
    let IDENTIFIER_NETICOME_TABLE_CELL = "NetIcomeTableViewCell"
    let IDENTIFIER_PIECHART_TABLE_CELL = "PieChartCategoryTableViewCell"
    let HEADER_INCOME = "INCOME"
    let HEADER_EXPENSE = "EXPENSE"
    let HEADER_BIG_EXPSENSE = "Biggest Expense"
    let NUMBER_SECTION = 5
    let NUMBER_ROW_SECTION = 1
    var fromDate: NSDate!
    var toDate: NSDate!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int!
    let context = AppDelegate.shareInstance.managedObjectContext
    var openingBalance = 0
    var endingBalance = 0
    var debt: Int64 = 0
    var loan: Int64 = 0
    var dataIncome = [[String: AnyObject]]()
    var dataExpense = [[String: AnyObject]]()
    var dataBigExpense = [[String: AnyObject]]()
    var arrTranSaction = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.tableView.allowsSelection = false
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ItemReportViewController.changeWallet(_:)), name: "changeWallet", object: nil)
        let currentMonthString = DataPageView.getMonthPage(pageIndex, toDate: NSDate()).1
        let currentMonthDate = DataPageView.getMonthPage(pageIndex, toDate: NSDate()).0
        monthLabel.text = "\(currentMonthString)"
        fromDate = currentMonthDate.startOfMonth()
        toDate = currentMonthDate.endOfMonth()
        requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "changeWallet", object: nil)
    }
    
    func changeWallet(notifi: NSNotification) {
        requestData()
    }
    
    func registerCell() {
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_BALANCE_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_BALANCE_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_ITEM_REPORT_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_ITEM_REPORT_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_NETICOME_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_NETICOME_TABLE_CELL)
        self.tableView.registerNib(UINib.init(nibName: IDENTIFIER_PIECHART_TABLE_CELL, bundle: nil),
             forCellReuseIdentifier: IDENTIFIER_PIECHART_TABLE_CELL)
    }
    
    func requestTransactionByCategory(categoryType: CategoryType) {
        let results = self.requestTransaction(self.fromDate!, toDate: self.toDate!, categoryType: categoryType,
            wallet: DataManager.shareInstance.currentWallet, groupBy: GroupBy.Category,
            functionType: FunctionType.Sum, resultType: NSFetchRequestResultType.DictionaryResultType)
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
                if categoryType == CategoryType.Expense {
                    dataExpense.append(dict)
                }
                if categoryType == CategoryType.Income {
                    dataIncome.append(dict)
                }
            }
        }
    }
    
    func requestData() {
        dataIncome.removeAll()
        dataExpense.removeAll()
        dataBigExpense.removeAll()
        openingBalance = 0
        endingBalance = 0
        requestTransactionByCategory(CategoryType.Expense)
        requestTransactionByCategory(CategoryType.Income)
        requestBigExpense()
        requestBalance()
        requestDataDebtLoan()
        self.tableView.reloadData()
    }
    
    func requestBigExpense() {
        let requestBigExpense = self.requestTransaction(NSDate.startOfDay(self.fromDate), toDate: NSDate.endOfDay(self.toDate),
            categoryType: CategoryType.Expense, wallet: DataManager.shareInstance.currentWallet,
            groupBy: GroupBy.None, functionType: FunctionType.Max, resultType: NSFetchRequestResultType.DictionaryResultType)
        if let arrGroup = requestBigExpense as? [[String: AnyObject]] {
            var dict: [String: AnyObject] = ["maxOfAmount": 0, "groupName": "", "groupImage": "","date": ""]
            if arrGroup.count > 0 {
                let item = arrGroup[0]
                let dayString = item["dayString"]
                let maxOfAmount = item["maxOfAmount"] as! Int
                let groupId = item["group"] as! NSManagedObjectID
                let group = context.objectWithID(groupId) as! Group
                let groupImage = group.imageName
                let groupName = group.name
                dict["maxOfAmount"] = maxOfAmount
                dict["groupName"] = groupName
                dict["groupImage"] = groupImage
                dict["date"] = dayString
                dataBigExpense.append(dict)
            }
        }
    }
    
    func requestBalance() {
        let requestOpeningBalance = self.requestTransaction(nil, toDate: NSDate.startOfDay(fromDate),
            categoryType: CategoryType.All, wallet: DataManager.shareInstance.currentWallet,
            groupBy: GroupBy.None, functionType: FunctionType.Sum, resultType: NSFetchRequestResultType.DictionaryResultType)
        let requestEndingBalance = self.requestTransaction(nil, toDate: NSDate.endOfDay(toDate),
            categoryType: CategoryType.All, wallet: DataManager.shareInstance.currentWallet,
            groupBy: GroupBy.None, functionType: FunctionType.Sum, resultType: NSFetchRequestResultType.DictionaryResultType)
        openingBalance = requestOpeningBalance![0]["sumOfAmount"] as! Int
        endingBalance = requestEndingBalance![0]["sumOfAmount"] as! Int
    }
    
    func requestDataDebtLoan() {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let arraySortDescriptor = [sortDescriptor]
        let request = NSFetchRequest(entityName: Transaction.CLASS_NAME)
        request.sortDescriptors = arraySortDescriptor
        let predicateWithDates = NSPredicate(format: "date >= %@ AND date <= %@",
            NSDate.startOfDay(fromDate), NSDate.endOfDay(toDate))
        let predicateChangeWallet = NSPredicate(format: "wallet == %@", DataManager.shareInstance.currentWallet)
        var compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateChangeWallet,
            predicateWithDates, NSPredicate.predicateWithDebtOrLoanTransaction(true)])
        request.predicate = compoundPredicate
        do {
            if let arrTransactionDebt = try context.executeFetchRequest(request) as? [Transaction] {
                for tran in arrTransactionDebt {
                    debt += tran.moneyNumber
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateWithDates,
            NSPredicate.predicateWithDebtOrLoanTransaction(false)])
        request.predicate = compoundPredicate
        do {
            if let arrTransactionLoan = try context.executeFetchRequest(request) as? [Transaction] {
                for tran in arrTransactionLoan {
                    loan += tran.moneyNumber
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func requestTransaction(fromDate: NSDate?, toDate: NSDate?, categoryType: CategoryType,
        wallet: Wallet, groupBy: GroupBy, functionType: FunctionType, resultType: NSFetchRequestResultType) -> [AnyObject]?{
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
}

extension ItemReportViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUMBER_SECTION
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_ROW_SECTION
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case NameSection.Balance.rawValue:
            let balanceCell = tableView.dequeueReusableCellWithIdentifier("BalanceTableViewCell", forIndexPath: indexPath) as! BalanceTableViewCell
            balanceCell.setDataBalance(openingBalance, end: endingBalance)
            return balanceCell
        case NameSection.NetIncome.rawValue:
            let netIcomeCell = tableView.dequeueReusableCellWithIdentifier("NetIcomeTableViewCell", forIndexPath: indexPath) as! NetIcomeTableViewCell
            netIcomeCell.netIncome.text = (endingBalance - openingBalance).stringFormatedWithSepator
            return netIcomeCell
        case NameSection.BigExpense.rawValue:
            let bigExpense = tableView.dequeueReusableCellWithIdentifier("ItemReportTableViewCell", forIndexPath: indexPath) as! ItemReportTableViewCell
            if dataBigExpense.count > 0 {
                let dict = dataBigExpense[0]
                bigExpense.setDataItem(dict)
            }
            return bigExpense
        case NameSection.Expense.rawValue:
            let expenseCell = tableView.dequeueReusableCellWithIdentifier("PieChartCategoryTableViewCell", forIndexPath: indexPath) as! PieChartCategoryTableViewCell
            expenseCell.setDataCharCategory(dataExpense)
            return expenseCell
        case NameSection.Income.rawValue:
            let incomeCell = tableView.dequeueReusableCellWithIdentifier("PieChartCategoryTableViewCell", forIndexPath: indexPath) as! PieChartCategoryTableViewCell
            incomeCell.setDataCharCategory(dataIncome)
            return incomeCell
        case NameSection.Debt.rawValue:
            let debtCell = tableView.dequeueReusableCellWithIdentifier("ItemReportTableViewCell", forIndexPath: indexPath) as! ItemReportTableViewCell
            debtCell.setDataDebtLoan(debt, isDebt: true)
            return debtCell
        default:
            let loanCell = tableView.dequeueReusableCellWithIdentifier("ItemReportTableViewCell", forIndexPath: indexPath) as! ItemReportTableViewCell
            loanCell.setDataDebtLoan(loan, isDebt: false)
            return loanCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case NameSection.Balance.rawValue:
            return HEIGHT_CELL_BALANCE
        case NameSection.Income.rawValue, NameSection.Expense.rawValue:
            return HEIGHT_CELL_PIECHART
        default:
            return HEIGHT_CELL_DEFAULT
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_HEADER
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case NameSection.Income.rawValue:
            return HEADER_INCOME
        case NameSection.Expense.rawValue:
            return HEADER_EXPENSE
        case NameSection.BigExpense.rawValue:
            return HEADER_BIG_EXPSENSE
        default:
            return ""
        }
    }
}
