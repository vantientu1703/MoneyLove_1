//
//  ResultsTransactionViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

class ResultsTransactionViewController: UIViewController {
    let CACHE_NAME = "Transaction_Result_Cache"
    let DATE_REQUEST_CELL_IDENTIFIER = "DATE_REQUEST_CELL_IDENTIFIER"
    let CATEGORY_CELL_IDENTIFIER = "CATEGORY_CELL_IDENTIFIER"
    let OVERVIEWCELL_IDENTIFIER = "OVERVIEWCELL_IDENTIFIER"
    let TITLE = "Search Transaction"
    let HEIGHT_OF_NORMALCELL: CGFloat = 50.0
    let HEIGHT_OF_HEADERCELL: CGFloat = 50.0
    let HEIGHT_OF_OVERVIEWCELL: CGFloat = 150.0
    @IBOutlet weak var myTableView: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    var data: DataResultTransaction!
    var predicate: NSPredicate! {
        didSet {
            fetchRequest = NSFetchRequest(entityName: Transaction.CLASS_NAME)
        }
    }
    var fetchRequest: NSFetchRequest! {
        didSet {
            let sortDescriptor = NSSortDescriptor(key: Transaction.DATE_VARIABLE_NAME, ascending: false)
            let arraySortDescriptor = [sortDescriptor]
            fetchRequest.sortDescriptors = arraySortDescriptor
            fetchRequest.predicate = predicate
            fetchedResultController =  NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath:"dayString", cacheName: self.CACHE_NAME)
        }
    }
    var fetchedResultController: NSFetchedResultsController!
        {
        didSet {
            fetchedResultController.delegate = self
            data = DataResultTransaction(frc: fetchedResultController, managedObjectContext: managedObjectContext)
            self.performRequest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.automaticallyAdjustsScrollViewInsets = false
        self.registerCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.myTableView.reloadData()
    }
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ResultsTransactionViewController.clickToCancel(_:)))
        title = TITLE
    }
    
    func registerCell(){
        myTableView.registerNib(UINib.init(nibName: "SearchOverViewCell", bundle: nil), forCellReuseIdentifier: OVERVIEWCELL_IDENTIFIER)
        myTableView.registerNib(UINib.init(nibName: "DateRequestedCell", bundle: nil), forCellReuseIdentifier: DATE_REQUEST_CELL_IDENTIFIER)
        myTableView.registerNib(UINib.init(nibName: "CategoryRequestedCell", bundle: nil), forCellReuseIdentifier: CATEGORY_CELL_IDENTIFIER)
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
    
    func clickToCancel(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func setDataForCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let newIndexPath = self.convertIndexPathOfTableViewToIndexPathOfFetchedResultsController(indexPath)
        if cell is SearchOverViewCell {
            let overViewCell = cell as! SearchOverViewCell
            overViewCell.configureCell(data)
        } else if cell is DateRequestedCell {
            let dateCell = cell as! DateRequestedCell
            dateCell.configureCellInSearchTransaction(newIndexPath, data: data)
        }else if cell is CategoryRequestedCell {
            let categoryCell = cell as! CategoryRequestedCell
            categoryCell.configureCellInSearchTransaction(newIndexPath, data: data)
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

extension ResultsTransactionViewController: NSFetchedResultsControllerDelegate {
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

extension ResultsTransactionViewController: TransactionViewControllerDelegate {
    func delegateDoWhenDeleteTrans(transRemoved: Transaction) {
        DataManager.shareInstance.removeTrans(transRemoved, fetchedResultsController: self.fetchedResultController)
    }
}

extension ResultsTransactionViewController: UITableViewDelegate, UITableViewDataSource {
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
            let overViewCell = tableView.dequeueReusableCellWithIdentifier(OVERVIEWCELL_IDENTIFIER, forIndexPath: indexPath) as! SearchOverViewCell
            self.setDataForCell(overViewCell, indexPath: indexPath)
            return overViewCell
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

