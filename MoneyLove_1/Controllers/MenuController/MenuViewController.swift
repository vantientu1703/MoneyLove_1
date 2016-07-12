//
//  MenuViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let HEIGHT_CELL_SECTION1: CGFloat = 60
    let HEIGHT_CELL_SECTION2: CGFloat = 70
    let HEIGHT_CELL_SECTION3: CGFloat = 44
    let arrTitle: Array = ["Transactions", "Debts", "Trends", "Monthly Report", "Categories"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.regisClassForCell()
    }
    
    func regisClassForCell() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellDefault")
        tableView.registerClass(HeaderOneTableViewCell.classForCoder(), forCellReuseIdentifier: "HeaderOneCell")
        tableView.registerNib(UINib.init(nibName: "HeaderOneTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderOneCell")
        tableView.registerClass(ShowWalletListTableViewCell.classForCoder(), forCellReuseIdentifier: "ShowWalletListTableViewCell")
        tableView.registerNib(UINib.init(nibName: "ShowWalletListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowWalletListTableViewCell")
    }
    // MARK: UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return arrTitle.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let headerOneCell = tableView.dequeueReusableCellWithIdentifier("HeaderOneCell", forIndexPath: indexPath)
            return headerOneCell
        } else if indexPath.section == 1 {
            let showWalletListCell = tableView.dequeueReusableCellWithIdentifier("ShowWalletListTableViewCell", forIndexPath: indexPath)
            return showWalletListCell
        } else {
            let identifier = "CellDefault"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
            cell.textLabel?.text = arrTitle[indexPath.row]
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HEIGHT_CELL_SECTION1
        } else if indexPath.section == 1 {
            return HEIGHT_CELL_SECTION2
        } else {
            return HEIGHT_CELL_SECTION3
        }
    }
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        switch indexPath.row {
            case 4:
                let categoriesVC = CategoriesViewController()
                self.sideMenuViewController.setContentViewController(UINavigationController(rootViewController: categoriesVC), animated: true)
                self.sideMenuViewController.hideMenuViewController()
                break
            default:
                break
        }
    }

}
