//
//  AllTransactionViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/13/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData
import WWCalendarTimeSelector

enum SectionType: Int {
    case OverviewSection = 0
    case BottomSection
}

enum CellType: Int {
    case Header = 0
    case Normal
}

enum TimeMode {
    case Day
    case Week
    case Month
    case Custom
    case Today
}

class AllTransactionViewController: UIViewController, RESideMenuDelegate {
    let CACHE_NAME = "MONEY_LOVER_CACHE"
    let OVERVIEWCELL_IDENTIFIER = "OVERVIEWCELL_IDENTIFIER"
    let DATE_REQUEST_CELL_IDENTIFIER = "DATE_REQUEST_CELL_IDENTIFIER"
    let CATEGORY_CELL_IDENTIFIER = "CATEGORY_CELL_IDENTIFIER"
    let CANCEL_ACTION_TITLE = "Cancel"
    let CHANGE_WALLET_ACTION_TITLE = "Change Wallet"
    let PERIOD_ACTION_TITLE = "Preiod"
    let COME_BACK_TODAY = "Come back today"
    let MONTH_ACTION_TITLE = "Month"
    let WEEK_ACTION_TITLE = "Week"
    let DAY_ACTION_TITLE = "Day"
    let CUSTOM_ACTION_TITLE = "Custom"
    let SEARCH_ACTION_TITLE = "Search"
    let CATEGORY_MODE = "Category Mode"
    let TIME_MODE = "Time Mode"
    let HEIGHT_OF_NORMALCELL: CGFloat = 50.0
    let HEIGHT_OF_HEADERCELL: CGFloat = 50.0
    let HEIGHT_OF_OVERVIEWCELL: CGFloat = 180.0
    var startDate: NSDate?
    var endDate: NSDate?
    var isSelectedStartDateLabel: Bool!
    var isCategoryMode = false {
        didSet {
            if fetchRequest != nil && managedObjectContext != nil {
                fetchRequest = NSFetchRequest.getFetchRequest(Transaction.CLASS_NAME, fromDate: startDate, toDate: endDate, categoryType: .All, wallet: DataManager.shareInstance.currentWallet, sortBy: isCategoryMode ? .Category : .Date)
            }
        }
    }
    var dataTransaction: DataTransaction?
    var managedObjectContext:NSManagedObjectContext!
    var index: Int! = 0
    var dateString: String? = "" {
        didSet {
            if let titleLabel = titleLabel {
                titleLabel.text = dateString
                fetchRequest = NSFetchRequest.getFetchRequest(Transaction.CLASS_NAME, fromDate: startDate, toDate: endDate, categoryType: .All, wallet: DataManager.shareInstance.currentWallet, sortBy: isCategoryMode ? .Category : .Date)
            }
        }
    }
    var timeMode: TimeMode! = .Day{
        didSet{
            if timeMode == .Custom || timeMode == .Today{
                if let pageVC = self.parentViewController as? CustomPageViewController {
                    pageVC.delegate = nil
                    pageVC.dataSource = nil
                }
            } else if oldValue == .Custom  || oldValue == .Today {
                if let pageVC = self.parentViewController as? CustomPageViewController {
                    pageVC.delegate = pageVC
                    pageVC.dataSource = pageVC
                }
            }
            self.getRangeTime(index, mode: timeMode)
        }
    }
    var fetchRequest: NSFetchRequest! {
        didSet {
            fetchedResultController =  NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: isCategoryMode ? "group.name" : "dayString", cacheName: self.CACHE_NAME)
        }
    }
    var fetchedResultController: NSFetchedResultsController!
        {
        didSet {
            fetchedResultController.delegate = self
            dataTransaction = DataTransaction(frc: fetchedResultController, managedObjectContext: managedObjectContext)
            self.performRequest()
            self.myTableView.reloadData()
        }
    }
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        self.getRangeTime(index, mode: timeMode)
        self.setUp()
        self.registerCell()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeWallet(_:)), name: "changeWallet", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "changeWallet", object: nil)
    }
    
    func setUp() {
        dataTransaction = DataTransaction(frc: fetchedResultController, managedObjectContext: managedObjectContext)
        addButton.layer.cornerRadius = 20.0
        addButton.backgroundColor = COLOR_NAVIGATION
        self.view.bringSubviewToFront(addButton)

    }
    
    func changeWallet(notifi: NSNotification) {
        fetchRequest = NSFetchRequest.getFetchRequest(Transaction.CLASS_NAME, fromDate: startDate, toDate: endDate, categoryType: .All, wallet: DataManager.shareInstance.currentWallet, sortBy: isCategoryMode ? .Category : .Date)
    }
    
    func getRangeTime(index: Int, mode: TimeMode) {
        switch mode {
        case .Day:
            let daySelected = DataPageView.getDayPage(index, firstDate: NSDate())
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            startDate = NSDate.startOfDay(daySelected)
            endDate = NSDate.endOfDay(daySelected)
            dateString = dateFormatter.stringFromDate(daySelected)
            break
        case .Week:
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday], fromDate: NSDate())
            components.calendar = calendar
            components.weekday = 2 // 2 = Monday
            let firstWeekDay = components.date
            let weekTuple = DataPageView.getWeeksPage(index, firstDate: firstWeekDay!)
            startDate = weekTuple.0
            endDate = weekTuple.1
            dateString = weekTuple.2
            break
        case .Month:
            let month = DataPageView.getMonthPage(index,toDate: NSDate())
            startDate = month.0.startOfMonth()
            endDate = month.0.endOfMonth()
            dateString = month.1
            break
        case .Custom:
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateString = "\(dateFormatter.stringFromDate(startDate!)) - \(dateFormatter.stringFromDate(endDate!))"
            break
        default:
            startDate = NSDate.startOfDay(NSDate())
            endDate = NSDate.endOfDay(NSDate())
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateString = dateFormatter.stringFromDate(startDate!)
            break
        }
    }
    
    func performRequest(){
        NSFetchedResultsController.deleteCacheWithName(CACHE_NAME)
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func registerCell(){
        myTableView.registerNib(UINib.init(nibName: "OverViewCell", bundle: nil), forCellReuseIdentifier: OVERVIEWCELL_IDENTIFIER)
        myTableView.registerNib(UINib.init(nibName: "DateRequestedCell", bundle: nil), forCellReuseIdentifier: DATE_REQUEST_CELL_IDENTIFIER)
        myTableView.registerNib(UINib.init(nibName: "CategoryRequestedCell", bundle: nil), forCellReuseIdentifier: CATEGORY_CELL_IDENTIFIER)
    }
    
    func clickToCancel(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func clickToChangeMode(sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let changeWallet = UIAlertAction(title: CHANGE_WALLET_ACTION_TITLE, style: UIAlertActionStyle.Default, handler: {[weak self] (alertAction) -> () in
            let walletVC = WalletManagerViewController(nibName: "WalletManagerViewController", bundle: nil)
            walletVC.managedObjectContext = self!.managedObjectContext
            walletVC.delegate = self!
            self?.presentViewController(walletVC, animated: true, completion: nil)
            })
        let comeBackToDay = UIAlertAction(title: COME_BACK_TODAY, style: UIAlertActionStyle.Default, handler: {[weak self] (alertAction) -> () in
            self?.timeMode = .Today
            })
        let rangeTime = UIAlertAction(title: PERIOD_ACTION_TITLE, style: UIAlertActionStyle.Default, handler:{[weak self] (alertAction) -> () in
            let rangeTimeAlertVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let rangeTimeAlertCancel = UIAlertAction(title: self?.CANCEL_ACTION_TITLE, style: UIAlertActionStyle.Cancel, handler: nil)
            let day = UIAlertAction(title: self?.DAY_ACTION_TITLE, style: UIAlertActionStyle.Default, handler: {[weak self] (alertAction) -> () in
                self?.timeMode = .Day
                })
            let week = UIAlertAction(title: self?.WEEK_ACTION_TITLE, style: UIAlertActionStyle.Default, handler: {[weak self] (alertAction) -> () in
                self?.timeMode = .Week
                })
            let month = UIAlertAction(title: self?.MONTH_ACTION_TITLE, style: UIAlertActionStyle.Default, handler: {[weak self] (alertAction) -> () in
                self?.timeMode = .Month
                })
            let custom = UIAlertAction(title: self?.CUSTOM_ACTION_TITLE, style: UIAlertActionStyle.Default, handler: {[weak self] (alertAction) -> () in
                dispatch_async(dispatch_get_main_queue(), {
                    CustomDateView.presentInViewController(self!)
                })
                })
            rangeTimeAlertVC .addAction(day)
            rangeTimeAlertVC.addAction(week)
            rangeTimeAlertVC.addAction(month)
            rangeTimeAlertVC.addAction(custom)
            rangeTimeAlertVC.addAction(rangeTimeAlertCancel)
            self?.presentViewController(rangeTimeAlertVC, animated: true, completion: nil)
            })
        let viewMode = UIAlertAction(title: isCategoryMode ? TIME_MODE : CATEGORY_MODE, style: UIAlertActionStyle.Default, handler:{[weak self] (alertAction) -> () in
            if self != nil {
                self!.isCategoryMode = !self!.isCategoryMode
            }
            })
        let search = UIAlertAction(title: SEARCH_ACTION_TITLE, style: UIAlertActionStyle.Default, handler: {[weak self] (alertAction) -> () in
            let searchTransactionVC = SearchTransactionViewController(nibName: "SearchTransactionViewController", bundle: nil)
            self?.navigationController?.pushViewController(searchTransactionVC, animated: true)
            })
        
        let cancel = UIAlertAction(title: CANCEL_ACTION_TITLE, style: UIAlertActionStyle.Cancel, handler: nil)
        alertVC.addAction(comeBackToDay)
        alertVC.addAction(rangeTime)
        alertVC.addAction(viewMode)
        alertVC.addAction(search)
        alertVC.addAction(cancel)
        alertVC.addAction(changeWallet)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func setDataForCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let newIndexPath = self.convertIndexPathOfTableViewToIndexPathOfFetchedResultsController(indexPath)
        if cell is OverViewCell {
            let overViewCell = cell as! OverViewCell
            overViewCell.configureCell(dataTransaction)
        } else if cell is DateRequestedCell {
            let dateCell = cell as! DateRequestedCell
            if indexPath.row == CellType.Header.rawValue {
                dateCell.configureCell(newIndexPath, data: dataTransaction, isHeader: true)
            } else {
                dateCell.configureCell(newIndexPath, data: dataTransaction, isHeader: false)
            }
        } else if cell is CategoryRequestedCell {
            let categoryCell = cell as! CategoryRequestedCell
            if indexPath.row == CellType.Header.rawValue {
                categoryCell.configureCell(newIndexPath, data: dataTransaction, isHeader: true)
            } else {
                categoryCell.configureCell(newIndexPath, data: dataTransaction, isHeader: false)
            }
        }
    }
    
    func convertIndexPathOfTableViewToIndexPathOfFetchedResultsController(indexPath: NSIndexPath) -> NSIndexPath {
        var section = 0
        var row = 0
        if indexPath.row != 0 {
            row = indexPath.row - 1
        }
        section = indexPath.section - 1
        let newIndexPath = NSIndexPath(forRow: row, inSection: section)
        return newIndexPath
    }
    
    func convertIndexPathOfFetchedResultsControllerToIndexPathOfTableView(indexPath: NSIndexPath) -> NSIndexPath{
        var section = 0
        var row = 0
        section = indexPath.section + 1
        row = indexPath.row + 1
        let newIndexPath = NSIndexPath(forRow: row, inSection: section)
        return newIndexPath
    }
    
    @IBAction func clickToAddTrans(sender: AnyObject) {
        let transVC =  TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        transVC.delegate = self
        transVC.fetchedResultsController = fetchedResultController
        navigationController?.pushViewController(transVC, animated: true)
    }
}

extension AllTransactionViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        myTableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let indexSet = NSIndexSet(index: sectionIndex + 1)
        switch type {
        case NSFetchedResultsChangeType.Insert:
            myTableView.insertSections(indexSet, withRowAnimation: .Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            myTableView.deleteSections(indexSet, withRowAnimation: .Fade)
            break
        case NSFetchedResultsChangeType.Update:
            myTableView.reloadSections(indexSet, withRowAnimation: .Fade)
            break
        case NSFetchedResultsChangeType.Move:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        var newIndexPathOfTableView: NSIndexPath?
        var indexPathOfTableView: NSIndexPath?
        if let newIndexPath = newIndexPath {
            newIndexPathOfTableView = self.convertIndexPathOfFetchedResultsControllerToIndexPathOfTableView(newIndexPath)
        }
        if let indexPath = indexPath {
            indexPathOfTableView = self.convertIndexPathOfFetchedResultsControllerToIndexPathOfTableView(indexPath)
        }
        switch (type) {
        case .Insert:
            if let newIndexPathOfTableView = newIndexPathOfTableView {
                myTableView.insertRowsAtIndexPaths([newIndexPathOfTableView], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPathOfTableView = indexPathOfTableView {
                myTableView.deleteRowsAtIndexPaths([indexPathOfTableView], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPathOfTableView = indexPathOfTableView {
                myTableView.reloadRowsAtIndexPaths([indexPathOfTableView], withRowAnimation: .Fade)
            }
            break;
        case .Move:
            if let indexPathOfTableView = indexPathOfTableView {
                myTableView.deleteRowsAtIndexPaths([indexPathOfTableView], withRowAnimation: .Fade)
            }
            if let newIndexPathOfTableView = newIndexPathOfTableView {
                myTableView.insertRowsAtIndexPaths([newIndexPathOfTableView], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        myTableView.endUpdates()
        DataManager.shareInstance.currentWallet.firstNumber = DataManager.shareInstance.getMoneyOfCurrentWallet()
    }
}

extension AllTransactionViewController: TransactionViewControllerDelegate {
    func delegateDoWhenDeleteTrans(transRemoved: Transaction) {
        DataManager.shareInstance.removeTrans(transRemoved, fetchedResultsController: self.fetchedResultController)
    }
}

extension AllTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultController.sections {
            if sections.count > 0 {
                return sections.count + 1
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultController.sections {
            if sections.count > 0 {
                if  section == 0 {
                    return 1
                } else {
                    let sectionInfo = sections[section - 1]
                    let numberOfObj = sectionInfo.numberOfObjects
                    return numberOfObj + 1
                }
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == SectionType.OverviewSection.rawValue {
            let overViewCell = tableView.dequeueReusableCellWithIdentifier(OVERVIEWCELL_IDENTIFIER, forIndexPath: indexPath) as! OverViewCell
            self.setDataForCell(overViewCell, indexPath: indexPath)
            return overViewCell
        } else {
            if isCategoryMode {
                if indexPath.row == CellType.Header.rawValue {
                    let categoryCell = tableView.dequeueReusableCellWithIdentifier(CATEGORY_CELL_IDENTIFIER, forIndexPath: indexPath) as! CategoryRequestedCell
                    self.setDataForCell(categoryCell, indexPath: indexPath)
                    return categoryCell
                } else {
                    let dateCell = tableView.dequeueReusableCellWithIdentifier(DATE_REQUEST_CELL_IDENTIFIER, forIndexPath: indexPath) as! DateRequestedCell
                    self.setDataForCell(dateCell, indexPath: indexPath)
                    return dateCell
                }
            } else {
                if indexPath.row == CellType.Header.rawValue {
                    let dateCell = tableView.dequeueReusableCellWithIdentifier(DATE_REQUEST_CELL_IDENTIFIER, forIndexPath: indexPath) as! DateRequestedCell
                    self.setDataForCell(dateCell, indexPath: indexPath)
                    return dateCell
                } else {
                    let categoryCell = tableView.dequeueReusableCellWithIdentifier(CATEGORY_CELL_IDENTIFIER, forIndexPath: indexPath) as! CategoryRequestedCell
                    self.setDataForCell(categoryCell, indexPath: indexPath)
                    return categoryCell
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionType.OverviewSection.rawValue:
            return HEIGHT_OF_OVERVIEWCELL
        default:
            if indexPath.row == CellType.Header.rawValue{
                return HEIGHT_OF_HEADERCELL
            } else {
                return HEIGHT_OF_NORMALCELL
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != SectionType.OverviewSection.rawValue && indexPath.row != CellType.Header.rawValue {
            let indexPathInFRC = self.convertIndexPathOfTableViewToIndexPathOfFetchedResultsController(indexPath)
            let trans = fetchedResultController.objectAtIndexPath(indexPathInFRC)
            let transVC = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
            transVC.delegate = self
            transVC.isNewTransaction = false
            transVC.managedTransactionObject = trans as! Transaction
            navigationController?.pushViewController(transVC, animated: true)
        }
    }
}

extension AllTransactionViewController: WalletManagerViewControllerDelegate {
    func didSelectWallet(wallet: Wallet) {
        DataManager.shareInstance.currentWallet = wallet
        DataManager.shareInstance.saveManagedObjectContext()
    }
}

extension AllTransactionViewController: CustomDateViewDelegate {
    func delegateDoWhenSave(startingDate: NSDate, endingDate: NSDate) {
        startDate = startingDate
        endDate = endingDate
        timeMode = .Custom
    }
    
    func delegateDoWhenShowCalendarVC(label: UILabel) {
        isSelectedStartDateLabel = label.tag == 1
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionCurrentDate = NSDate()
        selector.optionStyles = [.Date, .Year]
        self.presentViewController(selector, animated: true, completion: nil)
    }
    
    func customDateViewDoWhenCancel() {
        if let subView = self.view.viewWithTag(5) {
            subView.removeFromSuperview()
        }
    }
}
extension AllTransactionViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        if isSelectedStartDateLabel! {
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
