//
//  CustomDateViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import WWCalendarTimeSelector

enum DateType: Int {
    case STARTING_DATE = 0
    case ENDING_DATE
}
class CustomDateViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    let HEADER_TITLES = ["START", "END"]
    let NUMBER_OF_SECTION = 2
    let NUMBER_OF_ROW_IN_SECTION = 1
    let CELL_IDENTIFIER = "CELL_IDENTIFIER"
    var startingDate: NSDate?
    var endingDate: NSDate?
    var isStartDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.configureNavigationBar()
    }
    
    func configureNavigationBar() {
        let leftButton = UIBarButtonItem(title:"Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TransactionViewController.clickToCancel(_:)))
        let rightButton = UIBarButtonItem(title:"Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TransactionViewController.clickToSave(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func clickToCancel(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func clickToSave(sender: UIBarButtonItem) {
        
    }
}
extension CustomDateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUMBER_OF_SECTION
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROW_IN_SECTION
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CELL_IDENTIFIER)
        }
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        switch indexPath.section {
        case DateType.STARTING_DATE.rawValue:
            if let startingDate = startingDate {
                cell?.textLabel?.text = dateFormatter.stringFromDate(startingDate)
            } else {
                cell?.textLabel?.text = "Starting Date"
            }
        default:
            if let endingDate = endingDate {
                cell?.textLabel?.text = dateFormatter.stringFromDate(endingDate)
            } else {
                cell?.textLabel?.text = "Ending Date"
            }        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case DateType.STARTING_DATE.rawValue:
            isStartDate = true
        default:
            isStartDate = false
        }
        let selector = WWCalendarTimeSelector.instantiate()
        selector.navigationController?.setNavigationBarHidden(true, animated: false)
        selector.delegate = self
        selector.optionCurrentDate = NSDate()
        selector.optionStyles = [.Date, .Year]
        self.presentViewController(selector, animated: true, completion: nil)
    }
}

extension CustomDateViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        if isStartDate {
            startingDate = date
        } else {
            endingDate = date
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        myTableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: isStartDate ? DateType.STARTING_DATE.rawValue : DateType.ENDING_DATE.rawValue)], withRowAnimation: UITableViewRowAnimation.Automatic)
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