//
//  SearchSelectTableViewController.swift
//  MoneyLove_1
//
//  Created by Quang Huy on 7/25/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import WWCalendarTimeSelector

enum MoneySearchType: Int {
    case All = 0
    case Fewer
    case More
    case Accurate
    case Middle
    static let moneyNumberCases = [All, Fewer, More, Accurate, Middle]
    func title() -> String {
        switch self {
        case .All:
            return "All"
        case .Fewer:
            return "Fewer"
        case .More:
            return "More"
        case .Accurate:
            return "Accurate"
        default:
            return "Middle"
        }
    }
}

enum CategorySearchType: Int {
    case All = 0
    case Income
    case Expense
    static let categoryCases = [All, Income, Expense]
    func title() -> String {
        switch self {
        case .All:
            return "All"
        case .Income:
            return "Income"
        default:
            return "Expense"
        }
    }
}

enum TimeSearchType: Int {
    case All = 0
    case Before
    case After
    case Accurate
    case Middle
    static let timecases = [All, Before, After, Accurate, Middle]
    func title() -> String {
        switch self {
        case .All:
            return "All"
        case .Before:
            return "Before"
        case .After:
            return "After"
        case .Accurate:
            return "Accurate"
        default:
            return "Middle"
        }
    }
    
}

protocol SearchSelectTableViewDelegate: class {
    func searchWithWallet(wallet: Wallet)
    func searchWithDates(startDate: NSDate?, endDate: NSDate?, caseType: TimeSearchType)
    func searchWithDate(dateL: NSDate?, caseType: TimeSearchType)
    func searchWithMoney(from: Double?, to: Double?, caseType: MoneySearchType)
    func searchWithMoney(money: Double?, caseType: MoneySearchType)
    func searchWithCategory(caseType: CategorySearchType)
}

class SearchSelectTableViewController: UIViewController {
    let CELL_DEFAULT_IDENTIFIER = "cellDefault"
    let HEIGHT_CELL_DEFAULT: CGFloat = 50.0
    var allWallets:[Wallet]?
    var rowSelected: SelectRowType!
    var moneySearchType: MoneySearchType!
    var timeSearchType: TimeSearchType!
    var isSelectedStartDateLabel = false
    weak var delegate: SearchSelectTableViewDelegate!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.scrollEnabled = false
        allWallets = DataManager.shareInstance.getAllWallets()
        self.addTapGesture()
        self.setUpForRowSelected()
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SearchSelectTableViewController.clickToRemoveFromParentVC(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func clickToRemoveFromParentVC(gesture: UITapGestureRecognizer) {
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func setUpForRowSelected() {
        if rowSelected == .Wallet {
            headerLabel.text = "Select Wallet"
            if let allWallets = allWallets {
                heightOfTableView.constant = CGFloat(allWallets.count) * HEIGHT_CELL_DEFAULT
            } else {
                heightOfTableView.constant = 0.0
            }
        } else if rowSelected == .MoneyNumber {
            headerLabel.text = "Select Money"
            heightOfTableView.constant = CGFloat(MoneySearchType.moneyNumberCases.count) * HEIGHT_CELL_DEFAULT
        } else if rowSelected == .CategoryType {
            headerLabel.text = "Select Type"
            heightOfTableView.constant = CGFloat(CategorySearchType.categoryCases.count) * HEIGHT_CELL_DEFAULT
        } else if rowSelected == .Time {
            headerLabel.text = "Select Time"
            heightOfTableView.constant = CGFloat(TimeSearchType.timecases.count) * HEIGHT_CELL_DEFAULT
        }
    }
    
    func didSelectMoneySearchType(indexPath: NSIndexPath) {
        moneySearchType = MoneySearchType.moneyNumberCases[indexPath.row]
        if indexPath.row == MoneySearchType.Fewer.rawValue || indexPath.row == MoneySearchType.More.rawValue || indexPath.row == MoneySearchType.Accurate.rawValue {
            SearchExactlyMoneyView.presentInViewController(self)
        } else if indexPath.row == MoneySearchType.Middle.rawValue {
            SearchMoneySelectView.presentInViewController(self)
        }
    }
    
    func didSelectCategorySearchType(indexPath: NSIndexPath) {
        let categorySearchType = CategorySearchType.categoryCases[indexPath.row]
        delegate.searchWithCategory(categorySearchType)

    }
    
    func didSelectTimeSearchType(indexPath: NSIndexPath) {
        timeSearchType = TimeSearchType.timecases[indexPath.row]
        if indexPath.row == TimeSearchType.Before.rawValue || indexPath.row == TimeSearchType.After.rawValue || indexPath.row == TimeSearchType.Accurate.rawValue {
            let selector = WWCalendarTimeSelector.instantiate()
            selector.delegate = self
            selector.optionCurrentDate = NSDate(timeIntervalSinceReferenceDate: NSDate.timeIntervalSinceReferenceDate())
            selector.optionStyles = [.Date, .Year]
            self.presentViewController(selector, animated: true, completion: nil)
        } else if indexPath.row == TimeSearchType.Middle.rawValue {
            CustomDateView.presentInViewController(self)
        }
    }
    
    func removeFromParentVC() {
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension SearchSelectTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rowSelected == .Wallet {
            if let wallets = DataManager.shareInstance.getAllWallets() {
                return wallets.count
            }
            return 0
        } else if rowSelected == .MoneyNumber {
            return MoneySearchType.moneyNumberCases.count
        } else if rowSelected == .CategoryType {
            return CategorySearchType.categoryCases.count
        } else if rowSelected == .Time{
            return TimeSearchType.timecases.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellDefault = tableView.dequeueReusableCellWithIdentifier(CELL_DEFAULT_IDENTIFIER)
        if cellDefault == nil {
            cellDefault = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CELL_DEFAULT_IDENTIFIER)
        }
        
        if rowSelected == .Wallet {
            if let allWallets = allWallets {
                cellDefault?.textLabel?.text = allWallets[indexPath.row].name
                cellDefault?.imageView?.image = UIImage(named: allWallets[indexPath.row].imageName!)
            }
        } else if rowSelected == .MoneyNumber {
            let moneyCase = MoneySearchType.moneyNumberCases[indexPath.row]
            cellDefault?.textLabel?.text = moneyCase.title()
        } else if rowSelected == .CategoryType {
            let categoryCase = CategorySearchType.categoryCases[indexPath.row]
            cellDefault?.textLabel?.text = categoryCase.title()
        } else if rowSelected == .Time {
            let timeCase = TimeSearchType.timecases[indexPath.row]
            cellDefault?.textLabel?.text = timeCase.title()
        }
        return cellDefault!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL_DEFAULT
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if rowSelected == .Wallet {
            if let allWallets = allWallets {
                let walletSelected = allWallets[indexPath.row]
                delegate.searchWithWallet(walletSelected)
            }
        } else if rowSelected == .MoneyNumber {
            self.didSelectMoneySearchType(indexPath)
        } else if rowSelected == .CategoryType {
            self.didSelectCategorySearchType(indexPath)
        } else if rowSelected == .Time {
            self.didSelectTimeSearchType(indexPath)
        }
    }
}

extension SearchSelectTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let viewTouched = touch.view {
            if viewTouched.isDescendantOfView(tableView) {
                return false
            }
        }
        return true
    }
}

extension SearchSelectTableViewController: SearchExactlyMoneyDelegate {
    func delegateDoWhenSave(money: Double) {
        delegate.searchWithMoney(money, caseType: moneySearchType)
        self.removeFromParentVC()
    }
    func delegateDoWhenCancel() {
        self.removeFromParentVC()
    }
}

extension SearchSelectTableViewController: SearchMoneySelectDelegate {
    func searchMoneyDoWhenSave(from: Double, to: Double) {
        delegate.searchWithMoney(from, to: to, caseType: moneySearchType)
        self.removeFromParentVC()
    }
    
    func searchMoneyDoWhenCancel() {
        self.removeFromParentVC()
    }
}

extension SearchSelectTableViewController: CustomDateViewDelegate {
    func delegateDoWhenSave(startingDate: NSDate, endingDate: NSDate) {
        delegate.searchWithDates(startingDate, endDate: endingDate, caseType: timeSearchType)
        self.removeFromParentVC()
    }
    
    func delegateDoWhenShowCalendarVC(label: UILabel) {
        isSelectedStartDateLabel = label.tag == 1
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionCurrentDate = NSDate()
        selector.optionStyles = [.Date, .Year]
        self.presentViewController(selector, animated: true, completion: nil)
    }
}

extension SearchSelectTableViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        if isSelectedStartDateLabel {
            if let customDateView = self.view.viewWithTag(5) as? CustomDateView {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let startDateStr = dateFormatter.stringFromDate(date)
                customDateView.startingDate.text = startDateStr
                customDateView.start = date
            }
        } else {
            if let customDateView = self.view.viewWithTag(5) as? CustomDateView {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let endDateStr = dateFormatter.stringFromDate(date)
                customDateView.endingDate.text = endDateStr
                customDateView.end = date
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func WWCalendarTimeSelectorCancel(selector: WWCalendarTimeSelector, date: NSDate) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
