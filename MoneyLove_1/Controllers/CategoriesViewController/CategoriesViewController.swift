//
//  CategoriesViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData
enum SectionName: Int {
    case EXPENSE
    case INCOME
    case DEBTSLENDS
    static let allSections = [EXPENSE,INCOME,DEBTSLENDS]
    
    func title() -> String {
        switch self {
        case .EXPENSE:
            return "Expense"
        case .INCOME:
            return "Income"
        case .DEBTSLENDS:
            return "Debts & Lends"
        }
    }
}

protocol CategoriesViewControllerDelegate: class {
    func delegateDoWhenRowSelected(group: Group)
}

class CategoriesViewController: UIViewController, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var addButtonCategories: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let IDENTIFIER_CATEGORIES_TABLEVIEWCELL = "CategoriesTableViewCell"
    let HEIGHT_CELL_CATEGORIES: CGFloat = 50.0
    let TITLE_CATEGORIES = "Categories"
    let CACHE_NAME = "Group_Cache"
    let arrTitileCategories = SectionName.allSections
    var numberOfSectionInCoreData: Int = 0
    var managedObjectContext: NSManagedObjectContext!
    var typeExpense: Bool = false
    var isFromTransaction = false
    var delegate: CategoriesViewControllerDelegate!
    lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchedRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(Group.CLASS_NAME, inManagedObjectContext: self.managedObjectContext)
        fetchedRequest.entity = entity
        fetchedRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "subType", ascending: true)
        let arraySortDescriptor = [sortDescriptor]
        fetchedRequest.sortDescriptors = arraySortDescriptor
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "subType", cacheName: self.CACHE_NAME)
        aFetchedResultsController.delegate = self
        return aFetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TITLE_CATEGORIES
        self.view.backgroundColor = UIColor.grayColor()
        addButtonCategories.layer.cornerRadius = 20.0
        self.configureNavigationBar()
        self.configTableViewCell()
        self.performRequest()
    }
    
    func performRequest() {
        NSFetchedResultsController.deleteCacheWithName(self.CACHE_NAME)
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            let performError = error as NSError
            print("\(performError), \(performError.userInfo)")
        }
    }
    
    func configureNavigationBar() {
        if !isFromTransaction {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: MENU_TITLE, style: UIBarButtonItemStyle.Plain,
                target: self, action: #selector(UIViewController.presentLeftMenuViewController(_:)))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: MENU_TITLE, style: UIBarButtonItemStyle.Plain,
                target: self, action: #selector(CategoriesViewController.clickToBack(_:)))
        }
    }
    
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func clickToBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func buttonAddCategoriesPress(sender: AnyObject) {
        let addCategoriesVC = AddCategoriesViewController()
        addCategoriesVC.fetchedResultController = self.fetchedResultController
        addCategoriesVC.delegate = self
        self.navigationController?.pushViewController(addCategoriesVC, animated: true)
    }
    
    func configTableViewCell() {
        tableView.registerClass(CategoriesTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_CATEGORIES_TABLEVIEWCELL)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_CATEGORIES_TABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_CATEGORIES_TABLEVIEWCELL)
    }
    
    
    //MARK: UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultController.sections {
            let group = sections[section]
            return group.numberOfObjects
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let categoriesCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_CATEGORIES_TABLEVIEWCELL, forIndexPath: indexPath) as!CategoriesTableViewCell
        let categoryItem = self.fetchedResultController.objectAtIndexPath(indexPath) as! Group
        let name = categoryItem.name
        categoriesCell.labelMainCategories.text = name
        categoriesCell.imageViewCategories.image = UIImage(named: categoryItem.imageName!)
        return categoriesCell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if let numberOfSections = self.fetchedResultController.sections?.count {
            if numberOfSections == 1 {
                return nil
            } else if numberOfSections == 2 {
                if indexPath.section == 1 {
                    return nil
                } else {
                    let categoryItem = self.fetchedResultController.objectAtIndexPath(indexPath) as! Group
                    let editAction = UITableViewRowAction(style: .Default, title: EDIT) { [weak self](action, index) in
                        let addCategoriesVC = AddCategoriesViewController()
                        addCategoriesVC.statusEdit = EDIT
                        addCategoriesVC.categoryItem = categoryItem
                        self?.navigationController?.pushViewController(addCategoriesVC, animated: true)
                    }
                    editAction.backgroundColor = UIColor.greenColor()
                    
                    let deleteAction = UITableViewRowAction(style: .Default, title: DELETE_TITLE) { [weak self](action, index) in
                        self!.showAlertController(categoryItem)
                    }
                    deleteAction.backgroundColor = UIColor.redColor()
                    return [deleteAction, editAction]
                }
            } else {
                if indexPath.section == 2 {
                    return nil
                } else {
                    let categoryItem = self.fetchedResultController.objectAtIndexPath(indexPath) as! Group
                    let deleteAction = UITableViewRowAction(style: .Default, title: DELETE_TITLE) { [weak self](action, index) in
                        self!.showAlertController(categoryItem)
                    }
                    deleteAction.backgroundColor = UIColor.redColor()
                    
                    let editAction = UITableViewRowAction(style: .Default, title: EDIT) { [weak self](action, index) in
                        let addCategoriesVC = AddCategoriesViewController()
                        addCategoriesVC.statusEdit = EDIT
                        addCategoriesVC.categoryItem = categoryItem
                        self?.navigationController?.pushViewController(addCategoriesVC, animated: true)
                    }
                    editAction.backgroundColor = UIColor.greenColor()
                    return [deleteAction, editAction]
                }
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let numberOfSections = self.fetchedResultController.sections?.count {
            if numberOfSections == 1 {
                return false
            } else if numberOfSections == 2 {
                if indexPath.section == 1 {
                    return false
                } else {
                    return true
                }
            } else {
                if indexPath.section == 2 {
                    return false
                } else {
                    return true
                }
            }
        }
        return false
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL_CATEGORIES
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = self.fetchedResultController.sections {
            let group = sections[section]
            let title = group.indexTitle!
            switch title {
            case "0":
                return "Expense"
            case "1":
                return "Income"
            default:
                return "Debt And Loan"
            }
        }
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isFromTransaction {
            let group = fetchedResultController.objectAtIndexPath(indexPath) as! Group
            delegate.delegateDoWhenRowSelected(group)
        }
    }
    //MARK DELETE CategoryItem
    func showAlertController(categoryItem: Group) {
        let alertControlelr = UIAlertController(title: REMINDER_TITLE, message: MESSAGE_REMINDER_CATEGORY,
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionOk = UIAlertAction(title: OK_TITLE, style: .Destructive, handler: { [weak self](UIAlertAction) in
            DataManager.shareInstance.removeGroup(categoryItem, fetchedResultsController: self!.fetchedResultController)
            NSNotificationCenter.defaultCenter().postNotificationName(MESSAGE_ADD_NEW_TRANSACTION, object: nil)
        })
        let actionCancel = UIAlertAction(title: CANCEL_TITLE, style: .Default, handler: nil)
        alertControlelr.addAction(actionOk)
        alertControlelr.addAction(actionCancel)
        self.presentViewController(alertControlelr, animated: true, completion: nil)
    }
}

extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let indexSet = NSIndexSet(index: sectionIndex)
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Update:
            tableView.reloadSections(indexSet, withRowAnimation: .Fade)
            break
        case NSFetchedResultsChangeType.Move:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

extension CategoriesViewController: AddCategoriesViewControllerDelegate {
    func delegateDoWhenDelete(groupDeleted: Group) {
        
    }
}
