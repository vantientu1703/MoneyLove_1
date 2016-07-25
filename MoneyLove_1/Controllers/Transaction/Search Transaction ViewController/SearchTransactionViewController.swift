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
    case MoneyNumber
    case CategoryType
    case Time
    case Category
    case Note
    static let arrayTypes = [Wallet, MoneyNumber, CategoryType, Time, Category, Note]
   func title() -> String {
        switch self {
        case .Wallet:
            return "Wallet"
        case .MoneyNumber:
            return "MoneyNumber"
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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.scrollEnabled = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.registerCell()
        
    }
    
    func registerCell() {
        tableView.registerNib(UINib.init(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: CELL_SELECTED_IDENTIFIER)
        tableView.registerNib(UINib.init(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: NOTE_CELL_IDENTIFIER)
    }
    
    func getPredicateFromNote() -> NSPredicate? {
        let noteCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: SelectRowType.Note.rawValue, inSection: 0)) as! NoteCell
        let noteString = noteCell.textField.text
        var notePredicate: NSPredicate? = nil
//        if let note = noteString {
//             notePredicate = NSPredicate(format: "note == %@", note)
//        }
        return notePredicate
    }
    
    @IBAction func clickToSearch(sender: AnyObject) {
//        let note = self.getPredicateFromNote()
//        let notePredicate = NSPredicate(format: "note == %@", note)
        
    }
}

extension SearchTransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROW
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = SelectRowType.arrayTypes[indexPath.row]
        if indexPath.row == cellType.rawValue {
            let noteCell = tableView.dequeueReusableCellWithIdentifier(NOTE_CELL_IDENTIFIER, forIndexPath: indexPath) as! NoteCell
            noteCell.textField.delegate = self
            return noteCell
        } else {
            let searchCell = tableView.dequeueReusableCellWithIdentifier(CELL_SELECTED_IDENTIFIER, forIndexPath: indexPath) as! SearchCell
            searchCell.typeLabel.text = cellType.title()
            if indexPath.row == SelectRowType.Wallet.rawValue {
                searchCell.nameTypeLabel.text = walletName
            } else if indexPath.row == SelectRowType.MoneyNumber.rawValue {
                searchCell.nameTypeLabel.text = moneyNumber
            } else if indexPath.row == SelectRowType.CategoryType.rawValue {
                searchCell.nameTypeLabel.text = categoryType
            } else if indexPath.row == SelectRowType.Time.rawValue {
                searchCell.nameTypeLabel.text = dateString
            } else {
                searchCell.nameTypeLabel.text = groupName
            }
            return searchCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_OF_SEARCH_CELL
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowType = SelectRowType.arrayTypes[indexPath.row]
        if indexPath.row != rowType.rawValue && indexPath.row != rowType.rawValue {
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

extension SearchTransactionViewController: UITextFieldDelegate {
    
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
        var predicate: NSPredicate!
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
    
    func searchWithMoney(from: Double?, to: Double?, caseType: MoneySearchType) {
        let predicate = NSPredicate(format: "moneyNumber >= %@ AND moneyNumber <= %@", from!, to!)
        predicates[SelectRowType.MoneyNumber.rawValue] = predicate
        moneyNumber = "From ... To ... "
        let moneyIndexPath = NSIndexPath(forRow: SelectRowType.MoneyNumber.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([moneyIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

    }
    
    func searchWithDates(startDate: NSDate?, endDate: NSDate?, caseType: TimeSearchType) {
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate!, endDate!)
        predicates[SelectRowType.Time.rawValue] = predicate
        dateString = "Before... And... After"
        let dateIndexPath = NSIndexPath(forRow: SelectRowType.Time.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([dateIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func searchWithDate(dateL: NSDate?, caseType: TimeSearchType) {
        var predicate: NSPredicate!
        switch caseType {
        case .Before:
            dateString = "Before"
            predicate = NSPredicate(format: "date <= %@", dateL!)
            break
        case .After:
            dateString = "After"
            predicate = NSPredicate(format: "date >= %@", dateL!)
            break
        case .Accurate:
            dateString = ""
            predicate = NSPredicate(format: "date == %@", dateL!)
        default: break
        }
        predicates[SelectRowType.Time.rawValue] = predicate
        let dateIndexPath = NSIndexPath(forRow: SelectRowType.Time.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([dateIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

    }
    
    func searchWithMoney(money: Double?, caseType: MoneySearchType) {
        var predicate: NSPredicate!
        switch caseType {
        case .Fewer:
            moneyNumber = "Fewer"
            predicate = NSPredicate(format: "moneyNumber <= %@", money!)
            break
        case .More:
            moneyNumber = "More"
            predicate = NSPredicate(format: "moneyNumber >= %@", money!)
            break
        case .Accurate:
            moneyNumber = ""
            predicate = NSPredicate(format: "moneyNumber == %@", money!)
        default: break
        }
        predicates[SelectRowType.MoneyNumber.rawValue] = predicate
        let moneyIndexPath = NSIndexPath(forRow: SelectRowType.MoneyNumber.rawValue, inSection: 0)
        tableView.reloadRowsAtIndexPaths([moneyIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}

extension SearchTransactionViewController: CategoriesViewControllerDelegate {
    func delegateDoWhenRowSelected(group: Group) {
        let categoryIndexPath = NSIndexPath(forRow: SelectRowType.Category.rawValue, inSection: 0)
        let categoryCell = tableView.cellForRowAtIndexPath(categoryIndexPath)
        categoryCell?.textLabel?.text = group.name!
        tableView.reloadRowsAtIndexPaths([categoryIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}