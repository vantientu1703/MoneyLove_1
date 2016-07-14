//
//  CategoriesViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit  

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
    let arrTitileCategories = SectionName.allSections
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TITLE_CATEGORIES
        self.view.backgroundColor = UIColor.grayColor()
        addButtonCategories.layer.cornerRadius = 20.0
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.presentLeftMenuViewController(_:)))
        self.configTableViewCell()
    }
    
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
   
    @IBAction func buttonAddCategoriesPress(sender: AnyObject) {
        let addCategoriesVC = AddCategoriesViewController()
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
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let categoriesCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_CATEGORIES_TABLEVIEWCELL,
            forIndexPath: indexPath)
        // TODO
        return categoriesCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // TODO
        return HEIGHT_CELL_CATEGORIES * 6
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName = arrTitileCategories[section]
        return sectionName.title()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_SECTION
    }
}
