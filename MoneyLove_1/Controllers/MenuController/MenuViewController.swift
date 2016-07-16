//
//  MenuViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func showWalletViewController()
}

enum VIEWCONTROLLER: Int {
    case TransactionViewControllers, DebtsViewControllers, TrendsViewControllers, MonthlyReportViewControllers, CategoriesViewControllers
    static let allViewControlles = [TransactionViewControllers, DebtsViewControllers, TrendsViewControllers, MonthlyReportViewControllers, CategoriesViewControllers]
    
    func title() -> String {
        switch self {
        case .TransactionViewControllers:
            return "Transactions"
        case DebtsViewControllers:
            return "Debts"
        case TrendsViewControllers:
            return "Trends"
        case MonthlyReportViewControllers:
            return "Monthly Report"
        case CategoriesViewControllers:
            return "Categories"
        }
    }
    
    func viewController() -> UIViewController {
        switch self {
        case .TransactionViewControllers:
            let customPageVC = CustomPageViewController()
            let menuVC = MenuViewController()
            return customPageVC
        case DebtsViewControllers:
            let debtsVC = DebtViewController()
            return debtsVC
        case TrendsViewControllers:
            let trendsVC = TrendTableViewController()
            return trendsVC
        case MonthlyReportViewControllers:
            let mothlyReportVC = PageReportViewController()
            return mothlyReportVC
        case CategoriesViewControllers:
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let categoriesVC = CategoriesViewController()
            categoriesVC.managedObjectContext = appDelegate.managedObjectContext
            return categoriesVC
        }
    }
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: MenuViewControllerDelegate?
    var selectVC: SelectWalletViewController!
    var isShowSelectWallet: Bool?
    let arrViewControllers = VIEWCONTROLLER.allViewControlles
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonShowWalletList: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowSelectWallet = false
        tableView.delegate = self
        tableView.dataSource = self
        self.regisClassForCell()
    }
    
    func regisClassForCell() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellDefault")
    }
    // MARK: UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrViewControllers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CellDefault"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath:indexPath)
        let titleIndex = arrViewControllers[indexPath.row]
        cell.textLabel?.text = titleIndex.title()
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let viewControllerIndex = arrViewControllers[indexPath.row]
        let vc: UIViewController = viewControllerIndex.viewController()
        self.sideMenuViewController.setContentViewController(UINavigationController(rootViewController: vc), animated: true)
        self.sideMenuViewController.hideMenuViewController()
    }
    //MARK: ShowWalletListTableViewCellDelegate
    func showWalletController() {
        print("Press button delegate")
    }
    
    @IBAction func pressSelectWalletFromView(sender: AnyObject) {
        self.showSelectWalletViewController()
    }
    @IBAction func pressSelectWallet(sender: AnyObject) {
        self.showSelectWalletViewController()
    }
    //MARK init SelectWalletViewController
    func showSelectWalletViewController() {
        if self.isShowSelectWallet == false {
            selectVC = SelectWalletViewController()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            selectVC.managedObjectContext = appDelegate.managedObjectContext
            selectVC.view.frame = CGRectMake(0.0, 130.0, UIScreen.mainScreen().bounds.size.width - 100.0, 0.0)
            UIView.animateWithDuration(10.0, animations: { () -> Void in
                self.selectVC.view.frame = CGRectMake(0.0, 130.0, UIScreen.mainScreen().bounds.size.width - 100.0, UIScreen.mainScreen().bounds.size.height - 130.0)
            }) { Bool -> Void in
                self.addChildViewController(self.selectVC)
                self.selectVC.didMoveToParentViewController(self)
                self.view.addSubview(self.selectVC.view)
            }
            self.isShowSelectWallet = true
            self.buttonShowWalletList.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        } else {
            self.isShowSelectWallet = false
            self.selectVC.removeFromParentViewController()
            self.selectVC.view.removeFromSuperview()
            self.selectVC = nil
            self.buttonShowWalletList.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
        }
    }
}
