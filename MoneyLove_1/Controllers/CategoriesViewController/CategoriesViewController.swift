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

class CategoriesViewController: UIViewController, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addButtonCategories: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let IDENTIFIER_CATEGORIES_TABLEVIEWCELL = "CategoriesTableViewCell"
    let HEIGHT_CELL_CATEGORIES: CGFloat = 50.0
    let HEIGHT_SECTION: CGFloat = 25.0
    let TITLE_CATEGORIES = "Categories"
    let CACHE_NAME = "Group_Cache"
    let arrTitileCategories = SectionName.allSections
    var numberOfSectionInCoreData: Int = 0
    var managedObjectContext: NSManagedObjectContext!
    var typeExpense: Bool = true
    let DEBTS = "Debts"
    let TRENDS = "Trends"
    let IC_DEBTS = "ic_debts"
    let IC_TRENDS = "ic_trends"
    lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchedRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(Group.CLASS_NAME, inManagedObjectContext: self.managedObjectContext)
        fetchedRequest.entity = entity
        fetchedRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let arraySortDescriptor = [sortDescriptor]
        fetchedRequest.sortDescriptors = arraySortDescriptor
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "type", cacheName: self.CACHE_NAME)
        aFetchedResultsController.delegate = self
        return aFetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TITLE_CATEGORIES
        self.view.backgroundColor = UIColor.grayColor()
        addButtonCategories.layer.cornerRadius = 20.0
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.presentLeftMenuViewController(_:)))
        self.configTableViewCell()
        self.performRequest()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CategoriesViewController.typeBool(_:)), name: TYPE_BOOL, object: nil)
    }
    
    func typeBool(sender: AnyObject) {
        self.typeExpense = NSUserDefaults.standardUserDefaults().boolForKey(TYPE_BOOL)
    }
    
    func performRequest() {
        do {
            try fetchedResultController.performFetch()
        } catch {
            let performError = error as NSError
            print("\(performError), \(performError.userInfo)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if let sections = self.fetchedResultController.sections {
            numberOfSectionInCoreData = sections.count
        }
    }
    
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
   
    @IBAction func buttonAddCategoriesPress(sender: AnyObject) {
        let addCategoriesVC = AddCategoriesViewController()
        addCategoriesVC.fetchedResultController = self.fetchedResultController
        addCategoriesVC.typeBool = typeExpense
        self.navigationController?.pushViewController(addCategoriesVC, animated: true)
    }
    
    func configTableViewCell() {
        tableView.registerClass(CategoriesTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_CATEGORIES_TABLEVIEWCELL)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_CATEGORIES_TABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_CATEGORIES_TABLEVIEWCELL)
    }
    
    //MARK: UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrTitileCategories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultController.sections {
            numberOfSectionInCoreData = sections.count
        }
        if section == 2 {
            return 2
        } else {
            if numberOfSectionInCoreData == 0 {
                return 0
            } else {
                if numberOfSectionInCoreData == 1 {
                    if typeExpense {
                        if section == 0 {
                            let sections = self.fetchedResultController.sections
                            let numberOfRowInsections = sections![0].numberOfObjects
                            return numberOfRowInsections
                        } else {
                            return 0
                        }
                    } else {
                        if section == 0 {
                            return 0
                        } else {
                            let sections = self.fetchedResultController.sections
                            let numberOfRowInsections = sections![0].numberOfObjects
                            return numberOfRowInsections
                        }
                    }
                } else {
                    if let sections = self.fetchedResultController.sections {
                        let numberOfRowInsections = sections[section].numberOfObjects
                        return numberOfRowInsections
                    }
                }
            }
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let categoriesCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_CATEGORIES_TABLEVIEWCELL,
            forIndexPath: indexPath) as! CategoriesTableViewCell
        if indexPath.section != 2 {
                let categoryItem = self.fetchedResultController.objectAtIndexPath(indexPath) as! Group
                categoriesCell.labelMainCategories.text = categoryItem.name
                categoriesCell.imageViewCategories.image = UIImage(named: categoryItem.imageName!)
        } else {
            if indexPath.row == 0 {
                categoriesCell.labelMainCategories.text = DEBTS
                categoriesCell.imageViewCategories.image = UIImage(named: IC_DEBTS)
            } else {
                categoriesCell.labelMainCategories.text = TRENDS
                categoriesCell.imageViewCategories.image = UIImage(named: IC_TRENDS)
            }
        }
        return categoriesCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // TODO
        return HEIGHT_CELL_CATEGORIES
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName = arrTitileCategories[section]
        return sectionName.title()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if numberOfSectionInCoreData == 0 {
            if section == 2 {
                return HEIGHT_SECTION
            } else {
                return 0
            }
        } else {
            if numberOfSectionInCoreData == 1 {
                if typeExpense {
                    if section == 0 {
                        return HEIGHT_SECTION
                    } else if section == 1{
                        return 0
                    } else {
                        return HEIGHT_SECTION
                    }
                } else {
                    if section == 0 {
                        return 0
                    } else if section == 1 {
                        return HEIGHT_SECTION
                    } else {
                        return HEIGHT_SECTION
                    }
                }
            } else {
                return HEIGHT_SECTION
            }
        }
    }
}

extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        var indexPathNew: NSIndexPath?
        var indexPath1: NSIndexPath?
        if typeExpense {
            if let indexPath = indexPath {
                indexPath1 = NSIndexPath(forRow: indexPath.row, inSection: 0)
            }
            if let newIndexPath = newIndexPath {
                indexPathNew = NSIndexPath(forRow: newIndexPath.row, inSection: 0)
            }
        } else {
            if let indexPath = indexPath {
                indexPath1 = NSIndexPath(forRow: indexPath.row, inSection: 1)
            }
            if let newIndexPath = newIndexPath {
                indexPathNew = NSIndexPath(forRow: newIndexPath.row, inSection: 1)
            }
        }
        switch (type) {
        case .Insert:
                tableView.insertRowsAtIndexPaths([indexPathNew!], withRowAnimation: .Fade)
            break;
        case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath1!], withRowAnimation: .Fade)
            break;
        case .Update:
                tableView.rectForRowAtIndexPath(indexPath1!)
            break;
        case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath1!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([indexPathNew!], withRowAnimation: .Fade)
            break;
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

