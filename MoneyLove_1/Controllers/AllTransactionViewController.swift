//
//  AllTransactionViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/13/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

enum SectionType: Int {
    case OverviewSection = 0
    case BottomSection
}

enum CellType: Int {
    case Header = 0
    case Normal
}

class AllTransactionViewController: UIViewController, RESideMenuDelegate {
    let CACHE_NAME = "MONEY_LOVER_CACHE"
    let OVERVIEWCELL_IDENTIFIER = "OVERVIEWCELL_IDENTIFIER"
    let DATE_REQUEST_CELL_IDENTIFIER = "DATE_REQUEST_CELL_IDENTIFIER"
    let CATEGORY_CELL_IDENTIFIER = "CATEGORY_CELL_IDENTIFIER"
    let HEIGHT_OF_NORMALCELL: CGFloat = 44.0
    let HEIGHT_OF_HEADERCELL: CGFloat = 80.0
    let HEIGHT_OF_OVERVIEWCELL: CGFloat = 120.0
    
    var managedObjectContext:NSManagedObjectContext!
    var index: Int!
    var startDate: NSDate!
    var endDate: NSDate!
    var isCategoryMode = false
    var dataTransaction: DataTransaction?
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest.getFetchRequest(Transaction.CLASS_NAME, fromDate: self.startDate, toDate: self.endDate, categoryType: CategoryType.All)
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "dayString", cacheName: self.CACHE_NAME)
        aFetchedResultsController.delegate = self
        return aFetchedResultsController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let strDate = "2016-07-01"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDate = dateFormatter.dateFromString(strDate)
        endDate = NSDate()
        myTableView.allowsSelection = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AllTransactionViewController.presentLeftMenuViewController(_:)))
        self.configureNavigationBar()
        self.performRequest()
        self.registerCell()
    }
    
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }
    
    @IBAction func clickToAddTrans(sender: AnyObject) {
        if let newTrans = DataManager.shareInstance.addNewTransaction(fetchedResultController) {
            let transVC =  TransactionViewController(nibName: "TransactionViewController", bundle: nil)
            transVC.delegate = self
            transVC.managedTransactionObject = newTrans
            navigationController?.pushViewController(transVC, animated: true)
        } else {
            print("Unable to add new transaction")
        }
    }
    
    func configureNavigationBar() {
        let leftButton = UIBarButtonItem(title:"Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AllTransactionViewController.clickToCancel(_:)))
        let rightButton = UIBarButtonItem(title:"...", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AllTransactionViewController.clickToChangeMode(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func performRequest(){
        dataTransaction = DataTransaction(frc: fetchedResultController, managedObjectContext: managedObjectContext)
        do {
            try fetchedResultController.performFetch()
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
        let changeWallet = UIAlertAction(title: "Change Wallet", style: UIAlertActionStyle.Default, handler: nil)
        let comeBackToDay = UIAlertAction(title: "Come back Today", style: UIAlertActionStyle.Default, handler: nil)
        let rangeTime = UIAlertAction(title: "Period", style: UIAlertActionStyle.Default, handler:{[weak self] (alertAction) -> () in
            let rangeTimeAlertVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let rangeTimeAlertCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            let day = UIAlertAction(title: "Day", style: UIAlertActionStyle.Default, handler: nil)
            let week = UIAlertAction(title: "Week", style: UIAlertActionStyle.Default, handler: nil)
            let month = UIAlertAction(title: "Month", style: UIAlertActionStyle.Default, handler: nil)
            let all = UIAlertAction(title: "All", style: UIAlertActionStyle.Default, handler: nil)
            let custom = UIAlertAction(title: "Custom", style: UIAlertActionStyle.Default, handler: nil)
            rangeTimeAlertVC .addAction(day)
            rangeTimeAlertVC.addAction(week)
            rangeTimeAlertVC.addAction(month)
            rangeTimeAlertVC.addAction(all)
            rangeTimeAlertVC.addAction(custom)
            rangeTimeAlertVC.addAction(rangeTimeAlertCancel)
            self?.presentViewController(rangeTimeAlertVC, animated: true, completion: nil)
            })
        let viewMode = UIAlertAction(title: "Mode", style: UIAlertActionStyle.Default, handler: nil)
        let adjustBlance = UIAlertAction(title: "Adjust Blance", style: UIAlertActionStyle.Default, handler: nil)
        let search = UIAlertAction(title: "Search", style: UIAlertActionStyle.Default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertVC.addAction(comeBackToDay)
        alertVC.addAction(rangeTime)
        alertVC.addAction(viewMode)
        alertVC.addAction(adjustBlance)
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
}

extension AllTransactionViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        myTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let indexSet = NSIndexSet(index: sectionIndex + 1)
        switch type {
        case NSFetchedResultsChangeType.Insert:
            myTableView.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            myTableView.deleteSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Update:
            myTableView.rectForSection(sectionIndex)
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
                myTableView.rectForRowAtIndexPath(indexPathOfTableView)
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
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        myTableView.beginUpdates()
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
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultController.sections {
            if section == 0 {
                return 1
            } else {
                let sectionInfo = sections[section - 1]
                let numberOfObj = sectionInfo.numberOfObjects
                return numberOfObj + 1
            }
            
        }
        return 0
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
        //TODO
    }
}


