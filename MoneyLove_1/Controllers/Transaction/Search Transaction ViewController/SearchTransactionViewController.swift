//
//  SearchTransactionViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

//
//  SearchTransactionViewController.swift
//  MoneyLove_1
//
//  Created by Quang Huy on 7/25/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
enum SelectRowType: Int {
    case Wallet = 0
    case MoneyNumber = 1
    case CategoryType = 2
    case Time = 3
    case Category = 4
    case Note = 5
    static let arrayTypes = [Wallet, MoneyNumber, CategoryType, Time, Category, Note]
    func title() -> String {
        switch self {
        case .Wallet:
            return "Wallet"
        case .MoneyNumber:
            return "Money number"
        case .CategoryType:
            return "Type"
        case .Time:
            return "Time"
        case .Category:
            return "Category"
        default:
            return "Note"
        }
    }
}
class SearchTransactionViewController: UIViewController {
    let NUMBER_OF_ROW = 6
    let CELL_SELECTED_IDENTIFIER = "CELL_SELECTED_IDENTIFIER"
    let NOTE_CELL_IDENTIFIER = "NOTE_CELL_IDENTIFIER"
    let HEIGHT_OF_SEARCH_CELL: CGFloat = 50.0
    var walletName: String!
    var moneyNumber: String!
    var dateString: String!
    var groupName: String!
    var categoryType: String!
    var predicates = [NSPredicate?](count: SelectRowType.arrayTypes.count, repeatedValue: nil)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.scrollEnabled = false
        searchButton.backgroundColor = COLOR_NAVIGATION
        self.automaticallyAdjustsScrollViewInsets = false
        self.registerCell()
        
    }
    
    func registerCell() {
        tableView.registerNib(UINib.init(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: CELL_SELECTED_IDENTIFIER)
        tableView.registerNib(UINib.init(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: NOTE_CELL_IDENTIFIER)
    }
    
    func getPredicateFromNote() {
        let noteCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: SelectRowType.Note.rawValue, inSection: 0)) as! NoteCell
        let noteString = noteCell.textField.text
        var notePredicate: NSPredicate? = nil
        if let note = noteString {
            notePredicate = NSPredicate(format: "note == %@", note)
        }
        predicates[SelectRowType.Note.rawValue] = notePredicate
    }
    
    func getCompoundPredicate() -> NSPredicate {
        self.getPredicateFromNote()
        var predicateArr = [NSPredicate]()
        for predicate in predicates {
            if let predicate  = predicate {
                predicateArr.append(predicate)
            }
        }
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicateArr)
        return compoundPredicate
    }
    
    @IBAction func clickToSearch(sender: AnyObject) {
        let resultVC = ResultsTransactionViewController(nibName: "ResultsTransactionViewController", bundle: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        resultVC.managedObjectContext = appDelegate.managedObjectContext
        resultVC.predicate = self.getCompoundPredicate()
        navigationController?.pushViewController(resultVC, animated: true)
    }
}

extension SearchTransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROW
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = SelectRowType.arrayTypes[indexPath.row]
        if cellType == .Note {
            let noteCell = tableView.dequeueReusableCellWithIdentifier(NOTE_CELL_IDENTIFIER, forIndexPath: indexPath) as! NoteCell
            return noteCell
        } else {
            let searchCell = tableView.dequeueReusableCellWithIdentifier(CELL_SELECTED_IDENTIFIER, forIndexPath: indexPath) as! SearchCell
            searchCell.typeLabel.text = cellType.title()
            searchCell.typeLabel.textColor = UIColor.lightGrayColor()
            if indexPath.row == SelectRowType.Wallet.rawValue {
                searchCell.nameTypeLabel.text = walletName == nil ? "All" : walletName
            } else if indexPath.row == SelectRowType.MoneyNumber.rawValue {
                searchCell.nameTypeLabel.text = moneyNumber == nil ? "All" : moneyNumber
            } else if indexPath.row == SelectRowType.CategoryType.rawValue {
                searchCell.nameTypeLabel.text = categoryType == nil ? "All" : categoryType
            } else if indexPath.row == SelectRowType.Time.rawValue {
                searchCell.nameTypeLabel.text = dateString == nil ? "All" : dateString
            } else {
                searchCell.nameTypeLabel.text = groupName == nil ? "All" : groupName
            }
            return searchCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_OF_SEARCH_CELL
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowType = SelectRowType.arrayTypes[indexPath.row]
        if rowType != .Note && rowType != .Category {
            let childVC = SearchSelectTableViewController(nibName: "SearchSelectTableViewController", bundle: nil)
            childVC.delegate = self
            childVC.rowSelected = rowType
            self.addChildViewController(childVC)
            childVC.view.frame = self.view.bounds
            self.view .addSubview(childVC.view)
            childVC.didMoveToParentViewController(self)
        } else if indexPath.row == SelectRowType.Category.rawValue {
            let categoryVC = CategoriesViewController(nibName: "CategoriesViewController", bundle: nil)
            categoryVC.managedObjectContext = AppDelegate.shareInstance.managedObjectContext
            categoryVC.isFromTransaction = true
            categoryVC.delegate = self
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
}

extension SearchTransactionViewController: SearchSelectTableViewDelegate {
    func searchWithWallet(wallet: Wallet) {
        walletName = wallet.name
        let predicate = NSPredicate(format: "wallet.name == %@", wallet.name!)
        predicates[SelectRowType.Wallet.rawValue] = predicate
        let walletIndexPath = NSIndexPath(forRow: SelectRowType.Wallet.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([walletIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func searchWithCategory(caseType: CategorySearchType) {
        var predicate: NSPredicate? = nil
        if caseType == .Income {
            categoryType = "Income"
            predicate = NSPredicate(format: "group.type == true")
        } else if caseType == .Expense {
            categoryType = "Expense"
            predicate = NSPredicate(format: "group.type == false")
        } else {
            categoryType = "All"
        }
        predicates[SelectRowType.CategoryType.rawValue] = predicate
        let categoryTypeIndexPath = NSIndexPath(forRow: SelectRowType.CategoryType.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([categoryTypeIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func searchWithMoney(from: Int64?, to: Int64?, caseType: MoneySearchType) {
        let predicate = NSPredicate(format: "moneyNumber >= %f AND moneyNumber <= %f", from!, to!)
        predicates[SelectRowType.MoneyNumber.rawValue] = predicate
        moneyNumber = "From \(from!.stringFormatedWithSepator)đ to \(to!.stringFormatedWithSepator)đ "
        let moneyIndexPath = NSIndexPath(forRow: SelectRowType.MoneyNumber.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([moneyIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
    }
    
    func searchWithDates(startDate: NSDate?, endDate: NSDate?, caseType: TimeSearchType) {
        let startOfDay = NSDate.startOfDay(startDate!)
        let endOfDay = NSDate.endOfDay(endDate!)
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay, endOfDay)
        predicates[SelectRowType.Time.rawValue] = predicate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateFrom = dateFormatter.stringFromDate(startDate!)
        let dateTo = dateFormatter.stringFromDate(endDate!)
        dateString = "From \(dateFrom)  to \(dateTo)"
        let dateIndexPath = NSIndexPath(forRow: SelectRowType.Time.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([dateIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func searchWithDate(date: NSDate?, caseType: TimeSearchType) {
        var predicate: NSPredicate? = nil
        var startOfDay:NSDate!
        var endOfDay: NSDate!
        if caseType != .All {
            startOfDay = NSDate.startOfDay(date!)
            endOfDay = NSDate.endOfDay(date!)
        }
        switch caseType {
        case .Before:
            dateString = "Before "
            predicate = NSPredicate(format: "date <= %@", endOfDay)
            break
        case .After:
            dateString = "After "
            predicate = NSPredicate(format: "date >= %@", startOfDay)
            break
        case .Accurate:
            dateString = "Accurate "
            predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay, endOfDay)
        default:
            dateString = "All "
        }
        
        if caseType != .All {
            if let date = date {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateStr = dateFormatter.stringFromDate(date)
                dateString = dateString + "\(dateStr)"
            }
        }
        predicates[SelectRowType.Time.rawValue] = predicate
        let dateIndexPath = NSIndexPath(forRow: SelectRowType.Time.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([dateIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func searchWithMoney(money: Int64?, caseType: MoneySearchType) {
        var predicate: NSPredicate!
        switch caseType {
        case .Fewer:
            moneyNumber = "Fewer "
            predicate = NSPredicate(format: "moneyNumber <= %d", money!)
            break
        case .More:
            moneyNumber = "More "
            predicate = NSPredicate(format: "moneyNumber >= %d", money!)
            break
        case .Accurate:
            moneyNumber = "Accurate "
            predicate = NSPredicate(format: "moneyNumber == %d", money!)
        default:
            moneyNumber = "All "
            break
        }
        if caseType != .All {
            if let money = money {
                moneyNumber = moneyNumber + "\(money.stringFormatedWithSepator)"
            }
        }
        predicates[SelectRowType.MoneyNumber.rawValue] = predicate
        let moneyIndexPath = NSIndexPath(forRow: SelectRowType.MoneyNumber.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([moneyIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}

extension SearchTransactionViewController: CategoriesViewControllerDelegate {
    func delegateDoWhenRowSelected(group: Group) {
        let categoryIndexPath = NSIndexPath(forRow: SelectRowType.Category.rawValue, inSection: 0)
        groupName = group.name!
        self.tableView.reloadRowsAtIndexPaths([categoryIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.navigationController?.popViewControllerAnimated(true)
        let predicate = NSPredicate(format: "group.name == %@", group.name!)
        predicates[SelectRowType.Category.rawValue] = predicate
    }
}