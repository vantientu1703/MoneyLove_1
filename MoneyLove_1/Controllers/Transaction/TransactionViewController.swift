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
    func delegateDoWhenCancel(trans: Transaction?)
    func delegateDoWhenSave(trans: Transaction?)
}

enum RowType: Int  {
    case Category = 0
    case MoneyNumber
    case Note
    case Contact
    case Date
}

class TransactionViewController: UIViewController, NSFetchedResultsControllerDelegate {
    let NUMBER_ROW = 5
    let HEIGHT_CELL_TRANSACTION_DEFAULT: CGFloat = 50.0
    let HEIGHT_CELL_DEFAULT: CGFloat = 65
    let TEXT_CELL_INDENTIFIER = "TextCell"
    let DATE_CELL_IDENTIFIER = "DateCell"
    let LABEL_CELL_IDENTIFIER = "LabelCell"
    let CATEGORY_LABEL_TEXT = "Select Category"
    let CONTACT_LABEL_TEXT = "With"
    let NOTE_LABEL_TEXT = "Note"
    let INCOME_TITLE = "INCOME"
    let EXPENSE_TITLE = "EXPENSE"
    let DEBT_AND_LOAN_TITLE = "DEBT AND LOAN"
    let NOTE_TEXT_FIELD_TAG = 2
    let MONEY_NUMBER_TEXT_FIELD_TAG = 1
    @IBOutlet weak var myTableView: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    var managedTransactionObject: Transaction!
    var peopleRelated: String?
    weak var delegate: TransactionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        self.automaticallyAdjustsScrollViewInsets = false
        self.configureNavigationBar()
        self.registerCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        peopleRelated = self.managedTransactionObject.personRelated
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        myTableView.registerClass(TextCell.classForCoder(), forCellReuseIdentifier: TEXT_CELL_INDENTIFIER)
        myTableView.registerNib(UINib.init(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: TEXT_CELL_INDENTIFIER)
        myTableView.registerClass(DateCell.classForCoder(), forCellReuseIdentifier: DATE_CELL_IDENTIFIER)
        myTableView.registerNib(UINib.init(nibName: "DateCell", bundle: nil), forCellReuseIdentifier: DATE_CELL_IDENTIFIER)
    }
    
    @IBAction func clickToCancel(sender: AnyObject) {
        delegate?.delegateDoWhenCancel(managedTransactionObject)
    }
    
    @IBAction func clickToSave(sender: AnyObject) {
        delegate?.delegateDoWhenSave(managedTransactionObject)
    }
}
extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_ROW;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case RowType.Category.rawValue, RowType.Contact.rawValue:
            var labelCell = tableView.dequeueReusableCellWithIdentifier(LABEL_CELL_IDENTIFIER)
            if labelCell == nil {
                labelCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: LABEL_CELL_IDENTIFIER)
            }
            if indexPath.row == RowType.Category.rawValue{
                if (managedTransactionObject.group?.name?.isEmpty)! {
                    labelCell!.textLabel!.text = CATEGORY_LABEL_TEXT
                } else {
                    labelCell?.textLabel?.text = managedTransactionObject.group?.name
                }
            } else {
                if peopleRelated!.isEmpty {
                    labelCell?.textLabel?.text = CONTACT_LABEL_TEXT
                } else {
                    labelCell?.textLabel?.text = peopleRelated
                }
            }
            return labelCell!
        case RowType.MoneyNumber.rawValue, RowType.Note.rawValue:
            let textCell = tableView.dequeueReusableCellWithIdentifier(TEXT_CELL_INDENTIFIER, forIndexPath: indexPath) as! TextCell
            if indexPath.row == RowType.Note.rawValue {
                textCell.myTextField.placeholder = NOTE_LABEL_TEXT
                textCell.myTextField.keyboardType = UIKeyboardType.Default
                textCell.myTextField.tag = NOTE_TEXT_FIELD_TAG
                textCell.myTextField.text = managedTransactionObject.note
            } else {
                textCell.myTextField.keyboardType = UIKeyboardType.NumberPad
                textCell.myTextField.tag = MONEY_NUMBER_TEXT_FIELD_TAG
                textCell.myTextField.text = "\(managedTransactionObject.moneyNumber)"
            }
            textCell.myTextField.delegate = self
            return textCell
        case RowType.Date.rawValue:
            let dateCell = tableView.dequeueReusableCellWithIdentifier(DATE_CELL_IDENTIFIER, forIndexPath: indexPath) as! DateCell
            let dateMoment = moment(NSDate(timeIntervalSince1970: managedTransactionObject.date))
            let date = dateMoment.weekdayName
            let month = dateMoment.monthName
            let year = dateMoment.year
            let day = dateMoment.day
            dateCell.dateLabel.text = date
            dateCell.dayLabel.text = "\(day)"
            dateCell.monthAndYearLabel.text = month + " " + "\(year)"
            return dateCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL_DEFAULT
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case RowType.Category.rawValue:
            let tc = TabPageViewController.create()
            let debtVC = DetailGroupSelected(nibName: "DetailGroupSelected", bundle: nil)
            let expenseVC = DetailGroupSelected(nibName: "DetailGroupSelected", bundle: nil)
            let incomeVC = DetailGroupSelected(nibName: "DetailGroupSelected", bundle: nil)
            tc.tabItems = [(debtVC, DEBT_AND_LOAN_TITLE), (expenseVC, EXPENSE_TITLE), (incomeVC, INCOME_TITLE)]
            var option = TabPageOption()
            option.tabWidth = UIScreen.mainScreen().bounds.size.width/CGFloat(tc.tabItems.count)
            tc.option = option
            self.navigationController?.pushViewController(tc, animated: true)
        case RowType.Contact.rawValue:
            let contactVC = ContactViewController(nibName: "ContactViewController", bundle: nil)
            contactVC.delegate = self
            self.navigationController?.pushViewController(contactVC, animated: false)
        case RowType.Date.rawValue:
            let selector = WWCalendarTimeSelector.instantiate()
            selector.delegate = self
            selector.optionCurrentDate = NSDate(timeIntervalSince1970: managedTransactionObject.date)
            selector.optionStyles = [.Date, .Year]
            self.navigationController?.pushViewController(selector, animated: true)
        default:
            break
        }
    }
}

extension TransactionViewController: TransactionVCDelegate {
    func displayContact(newName: String?) {
        peopleRelated = newName
        managedTransactionObject.personRelated = peopleRelated
        let indexPath = NSIndexPath(forRow: RowType.Contact.rawValue, inSection: 0)
        dispatch_async(dispatch_get_main_queue()) {
            self.myTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}

extension TransactionViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        managedTransactionObject.date = date.timeIntervalSince1970
        self.navigationController?.popViewControllerAnimated(true)
        myTableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: RowType.Date.rawValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func WWCalendarTimeSelectorCancel(selector: WWCalendarTimeSelector, date: NSDate) {
        self.navigationController?.popViewControllerAnimated(true)
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

extension TransactionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == MONEY_NUMBER_TEXT_FIELD_TAG {
            let moneyNumberStr = textField.text
            let moneyNumber = Double(moneyNumberStr!)
            managedTransactionObject.moneyNumber = moneyNumber!
        } else {
            managedTransactionObject.note = textField.text
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //TODO
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
}
