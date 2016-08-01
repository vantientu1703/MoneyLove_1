//
//  TransactionViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData
import TabPageViewController
import WWCalendarTimeSelector
import SwiftMoment

protocol TransactionViewControllerDelegate: class {
    func delegateDoWhenDeleteTrans(transRemoved: Transaction)
}

enum RowType: Int  {
    case Category = 0
    case MoneyNumber
    case Note
    case Contact
    case Date
    static let rowTypes = [Category, MoneyNumber, Note, Contact, Date]
    
    func title() -> String {
        switch self {
        case .Category:
            return "Select Category"
        case .MoneyNumber:
            return "Enter amount of money"
        case .Note:
            return "Enter something to remember"
        case .Contact:
            return "With"
        default:
            return ""
        }
    }
    
    func imageName() -> String {
        switch self {
        case .Category:
            return "question"
        case .MoneyNumber:
            return ""
        case .Note:
            return "pen"
        case .Contact:
            return "addContact"
        default:
            return ""
        }
    }
}

enum ErrorValue {
    case Pass
    case NoMoney
    case NoCategory
}

class TransactionViewController: UIViewController, NSFetchedResultsControllerDelegate {
    let NUMBER_ROW = 5
    let HEIGHT_CELL_TRANSACTION_DEFAULT: CGFloat = 50.0
    let TEXT_CELL_INDENTIFIER = "TextCell"
    let DATE_CELL_IDENTIFIER = "DateCell"
    let LABEL_CELL_IDENTIFIER = "LabelCell"
    let INCOME_TITLE = "INCOME"
    let EXPENSE_TITLE = "EXPENSE"
    let DEBT_AND_LOAN_TITLE = "DEBT AND LOAN"
    let NOTE_TEXT_FIELD_TAG = 2
    let MONEY_NUMBER_TEXT_FIELD_TAG = 1
    var isSelectedCategory = false
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var managedTransactionObject:Transaction!
    var fetchedResultsController: NSFetchedResultsController?
    weak var delegate: TransactionViewControllerDelegate?
    var transactionCache:(note: String?, date: NSTimeInterval, people: String?, money: Int64, group: Group?, wallet: Wallet?) = ("", 0, "", 0, nil, nil)
    var isNewTransaction = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        self.automaticallyAdjustsScrollViewInsets = false
        self.configureNavigationBar()
        self.title = "Add Transaction"
        self.registerCell()
        if !isNewTransaction {
            isSelectedCategory = true
            self.assignFromManagedObjectToCache()
        } else {
            transactionCache.date = NSDate().timeIntervalSinceReferenceDate
            transactionCache.wallet = DataManager.shareInstance.currentWallet
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        deleteButton.hidden = isNewTransaction
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavigationBar() {
        let leftButton = UIBarButtonItem(title:"Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TransactionViewController.clickToCancel(_:)))
        let rightButton = UIBarButtonItem(title:"Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TransactionViewController.clickToSave(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func registerCell() {
        myTableView.registerNib(UINib.init(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: LABEL_CELL_IDENTIFIER)
        myTableView.registerNib(UINib.init(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: TEXT_CELL_INDENTIFIER)
        myTableView.registerNib(UINib.init(nibName: "DateCell", bundle: nil), forCellReuseIdentifier: DATE_CELL_IDENTIFIER)
    }
    
    func assignFromManagedObjectToCache() {
        transactionCache.date = managedTransactionObject.date == 0 ? NSDate().timeIntervalSinceReferenceDate : managedTransactionObject.date
        transactionCache.note = managedTransactionObject.note
        transactionCache.money = managedTransactionObject.moneyNumber
        transactionCache.people = managedTransactionObject.personRelated
        transactionCache.group = managedTransactionObject.group
        transactionCache.wallet = managedTransactionObject.wallet
    }
    
    func assignFromCacheToManagedObject() {
        managedTransactionObject.note = transactionCache.note
        managedTransactionObject.date = transactionCache.date
        managedTransactionObject.moneyNumber = transactionCache.money
        managedTransactionObject.personRelated = transactionCache.people
        managedTransactionObject.group = transactionCache.group
        managedTransactionObject.wallet = transactionCache.wallet
        let currentDate = NSDate(timeIntervalSinceReferenceDate: managedTransactionObject.date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        managedTransactionObject.dayString = dateFormatter.stringFromDate(currentDate)
        managedTransactionObject.monthString = NSDate.getMonthStringFromDate(NSDate(timeIntervalSinceReferenceDate: managedTransactionObject.date))
    }
    
    func insertTransaction() {
        if let newTrans = DataManager.shareInstance.addNewTransaction(fetchedResultsController!) {
            managedTransactionObject = newTrans
        } else {
            errorLabel.text = "Unable to insert new transaction"
        }
    }
    
    func retrieveTextFromTextField() {
        let moneyIndexPath = NSIndexPath(forRow: RowType.MoneyNumber.rawValue, inSection: 0)
        let noteIndexPath = NSIndexPath(forRow: RowType.Note.rawValue, inSection: 0)
        let moneyTextField = myTableView.cellForRowAtIndexPath(moneyIndexPath) as! TextCell
        let noteTextField = myTableView.cellForRowAtIndexPath(noteIndexPath) as! TextCell
        let arrayText = moneyTextField.myTextField.text!.componentsSeparatedByString(",")
        let newNumberText = arrayText.joinWithSeparator("")
        if let moneyNumber = Int64(newNumberText) {
            transactionCache.money = moneyNumber
        } else {
            transactionCache.money = 0
        }
        transactionCache.note = noteTextField.myTextField.text
    }
    
    func checkValue() -> ErrorValue {
        let moneyIndexPath = NSIndexPath(forRow: RowType.MoneyNumber.rawValue, inSection: 0)
        let moneyTextField = myTableView.cellForRowAtIndexPath(moneyIndexPath) as! TextCell
        
        if let moneyString = moneyTextField.myTextField.text {
            let arrayText = moneyString.componentsSeparatedByString(",")
            let newNumberText = arrayText.joinWithSeparator("")
            if newNumberText == "" {
                return .NoMoney
            }
            if let moneyNumber = Int64(newNumberText) {
                if moneyNumber == 0 {
                    return .NoMoney
                }
            }
        }
        if !isSelectedCategory {
            return .NoCategory
        }
        return .Pass
    }
    
    func formatString(textField: UITextField) {
        let textArray = textField.text!.componentsSeparatedByString(",")
        let newText = textArray.joinWithSeparator("")
        let number = Int64(newText)
        let stringFormatted = number?.stringFormatedWithSepator
        textField.text = stringFormatted
    }
    
    @IBAction func clickToCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clickToSave(sender: AnyObject) {
        self.retrieveTextFromTextField()
        switch self.checkValue()  {
        case .Pass:
            errorLabel.text = ""
            if isNewTransaction {
                self.insertTransaction()
                NSNotificationCenter.defaultCenter().postNotificationName(MESSAGE_ADD_NEW_TRANSACTION, object: nil)
                NSNotificationCenter.defaultCenter().postNotificationName(POST_CURRENT_WALLET, object: nil)
            }
            self.assignFromCacheToManagedObject()
            DataManager.shareInstance.saveManagedObjectContext()
            navigationController?.popViewControllerAnimated(true)
            break
        case .NoCategory:
            errorLabel.text = "You did not select category"
            break
        case .NoMoney:
            errorLabel.text = "You did not select amount of money"
            break
        }
    }
    
    @IBAction func clickToDelete(sender: AnyObject) {
        delegate?.delegateDoWhenDeleteTrans(managedTransactionObject)
    }
}
extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_ROW;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowType = RowType.rowTypes[indexPath.row]
        switch rowType {
        case .Category, .Contact:
            let labelCell = tableView.dequeueReusableCellWithIdentifier(LABEL_CELL_IDENTIFIER, forIndexPath: indexPath) as! LabelCell
            if indexPath.row == RowType.Category.rawValue{
                if let group = transactionCache.group {
                    let groupName = group.name!
                    if groupName.isEmpty {
                        labelCell.nameLabel.text = rowType.title()
                        labelCell.nameLabel.textColor = UIColor.lightGrayColor()
                    } else {
                        labelCell.nameLabel.text = groupName
                        labelCell.nameLabel.textColor = UIColor.blackColor()
                    }
                    let groupImageName = group.imageName!
                    if !groupImageName.isEmpty {
                        labelCell.imageLabelCell.image = UIImage(named: groupImageName)
                    } else {
                        labelCell.imageLabelCell.image = UIImage(named: rowType.imageName())
                    }
                } else {
                    labelCell.nameLabel.text = rowType.title()
                    labelCell.nameLabel.textColor = UIColor.lightGrayColor()
                    labelCell.imageLabelCell.image = UIImage(named: rowType.imageName())
                }
            } else {
                labelCell.imageLabelCell.image = UIImage(named: "addContact")
                if let people = transactionCache.people {
                    if people.isEmpty {
                        labelCell.nameLabel.text = rowType.title()
                        labelCell.nameLabel.textColor = UIColor.lightGrayColor()
                    } else {
                        labelCell.nameLabel.text = transactionCache.people
                        labelCell.nameLabel.textColor = UIColor.blackColor()
                    }
                }else {
                    labelCell.nameLabel.text = rowType.title()
                    labelCell.nameLabel.textColor = UIColor.lightGrayColor()
                }
            }
            return labelCell
        case .MoneyNumber, .Note:
            let textCell = tableView.dequeueReusableCellWithIdentifier(TEXT_CELL_INDENTIFIER, forIndexPath: indexPath) as! TextCell
            if rowType == .Note {
                textCell.myTextField.placeholder = rowType.title()
                textCell.myTextField.keyboardType = UIKeyboardType.Default
                textCell.myTextField.tag = NOTE_TEXT_FIELD_TAG
                textCell.myImageView.image = UIImage(named: rowType.imageName())
                if let note = transactionCache.note {
                    textCell.myTextField.text = note
                } else {
                    textCell.myTextField.text = ""
                }
            } else {
                textCell.myTextField.keyboardType = UIKeyboardType.NumberPad
                textCell.myTextField.delegate = self
                textCell.myTextField.text = transactionCache.money == 0 ? nil : transactionCache.money.stringFormatedWithSepator
                textCell.myTextField.tag = MONEY_NUMBER_TEXT_FIELD_TAG
                textCell.myTextField.placeholder = rowType.title()
                textCell.myTextField.font = UIFont.systemFontOfSize(20, weight: UIFontWeightThin)
                textCell.myTextField.addTarget(self, action: #selector(TransactionViewController.formatString(_:)), forControlEvents: UIControlEvents.EditingChanged)
            }
            return textCell
        case .Date:
            let dateCell = tableView.dequeueReusableCellWithIdentifier(DATE_CELL_IDENTIFIER, forIndexPath: indexPath) as! DateCell
            let dateObj = NSDate(timeIntervalSinceReferenceDate: transactionCache.date)
            let dateMoment = moment(dateObj)
            let date = dateMoment.weekdayName
            let month = dateMoment.monthName
            let year = dateMoment.year
            let day = dateMoment.day
            dateCell.dateLabel.text = date
            dateCell.dayLabel.text = "\(day)"
            dateCell.monthAndYearLabel.text = month + " " + "\(year)"
            return dateCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL_TRANSACTION_DEFAULT
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case RowType.Category.rawValue:
            let categoryVC = CategoriesViewController(nibName: "CategoriesViewController", bundle: nil)
            categoryVC.managedObjectContext = AppDelegate.shareInstance.managedObjectContext
            categoryVC.isFromTransaction = true
            categoryVC.selecteCategory = SELECT_CATEGORY
            categoryVC.delegate = self
            self.navigationController?.pushViewController(categoryVC, animated: true)
        case RowType.Contact.rawValue:
            let contactVC = ContactViewController(nibName: "ContactViewController", bundle: nil)
            contactVC.delegate = self
            self.navigationController?.pushViewController(contactVC, animated: false)
        case RowType.Date.rawValue:
            let selector = WWCalendarTimeSelector.instantiate()
            selector.delegate = self
            selector.optionCurrentDate = NSDate(timeIntervalSinceReferenceDate: transactionCache.date)
            selector.optionStyles = [.Date, .Year]
            self.presentViewController(selector, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension TransactionViewController: TransactionVCDelegate {
    func displayContact(newName: String?) {
        transactionCache.people = newName
        let indexPath = NSIndexPath(forRow: RowType.Contact.rawValue, inSection: 0)
        dispatch_async(dispatch_get_main_queue()) {
            self.myTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}

extension TransactionViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        transactionCache.date = date.timeIntervalSinceReferenceDate
        self.dismissViewControllerAnimated(true, completion: nil)
        myTableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: RowType.Date.rawValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func WWCalendarTimeSelectorCancel(selector: WWCalendarTimeSelector, date: NSDate) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func WWCalendarTimeSelectorShouldSelectDate(selector: WWCalendarTimeSelector, date: NSDate) -> Bool {
        return true
    }
    func WWCalendarTimeSelectorWillDismiss(selector: WWCalendarTimeSelector) {
        //TODO
    }
    func WWCalendarTimeSelectorDidDismiss(selector: WWCalendarTimeSelector) {
        //TODO
    }
}

extension TabPageViewController {
    func clickToBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickToSearch(sender: UIBarButtonItem) {
        let searchGroupVC = SearchGroupViewController(nibName: "SearchGroupViewController", bundle: nil)
        self.navigationController?.pushViewController(searchGroupVC, animated: true)
    }
    
    func clickToChangeModeDisplay(sender: UIBarButtonItem) {
        //TODO
    }
}

extension TabPageViewController: SearchGroupDelegate {
    func doWhenClickBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func doWhenRowSelected(group: Group) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension TransactionViewController: CategoriesViewControllerDelegate {
    func delegateDoWhenRowSelected(group: Group) {
        let categoryIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        transactionCache.group = group
        isSelectedCategory = true
        myTableView.reloadRowsAtIndexPaths([categoryIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension TransactionViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength = MAX_LENGTH_CHARACTER
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
}
