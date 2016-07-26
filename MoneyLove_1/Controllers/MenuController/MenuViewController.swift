//
//  MenuViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import TabPageViewController

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
            return customPageVC
        case DebtsViewControllers:
            let tabPageVC: TabPageViewController = TabPageViewController.create()
            tabPageVC.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Left", style: UIBarButtonItemStyle.Plain, target: tabPageVC, action: #selector(TabPageViewController.presentLeftMenuViewController(_:)))
            tabPageVC.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: tabPageVC, action: #selector(TabPageViewController.add(_:)))
            let payableVC = PayReceiavableTableViewController(nibName: "PayReceiavableTableViewController", bundle: nil)
            payableVC.color = UIColor.greenColor()
            let receivableVC = PayReceiavableTableViewController(nibName: "PayReceiavableTableViewController", bundle: nil)
            payableVC.color = UIColor.redColor()
            tabPageVC.tabItems = [(payableVC, "Payable"), (receivableVC, "Receivable")]
            var option = TabPageOption()
            option.tabWidth = UIScreen.mainScreen().bounds.size.width / CGFloat(tabPageVC.tabItems.count)
            tabPageVC.option = option
            tabPageVC.title = "DEBTS"
            return tabPageVC
        case TrendsViewControllers:
            let trendsVC = TrendTableViewController()
            return trendsVC
        case MonthlyReportViewControllers:
            let mothlyReportVC = MonthlyReportViewController()
            return mothlyReportVC
        case CategoriesViewControllers:
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let categoriesVC = CategoriesViewController()
            categoriesVC.managedObjectContext = appDelegate.managedObjectContext
            return categoriesVC
        }
    }
    
    func imageName() -> String {
        switch self {
        case .TransactionViewControllers:
            return "ic_transaction"
        case DebtsViewControllers:
            return "ic_debt"
        case TrendsViewControllers:
            return "ic_trends"
        case MonthlyReportViewControllers:
            return "ic_report"
        case CategoriesViewControllers:
            return "ic_category"
        }
    }
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelTotalMoneyOfWallet: UILabel!
    @IBOutlet weak var labelWalletName: UILabel!
    @IBOutlet weak var imageViewWallet: UIImageView!
    weak var delegate: MenuViewControllerDelegate?
    var selectVC: SelectWalletViewController!
    var isShowSelectWallet: Bool?
    let arrViewControllers = VIEWCONTROLLER.allViewControlles
    let IDENTIFIER_MENU_TABLEVIEW_CELL = "MenuViewControllerTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonShowWalletList: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowSelectWallet = false
        tableView.delegate = self
        tableView.dataSource = self
        self.regisClassForCell()
        self.getWalletDefault()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuViewController.getWalletDefault), name: POST_CURRENT_WALLET, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuViewController.hiddenSelectWalletViewController), name: MESSAGE_ADD_NEW_TRANSACTION, object: nil)
    }
    
    func hiddenSelectWalletViewController() {
        self.isShowSelectWallet = true
        self.showSelectWalletViewController()
    }
    
    func getWalletDefault() {
        if let wallet = DataManager.shareInstance.currentWallet {
            self.imageViewWallet.image = UIImage(named: wallet.imageName!)
            self.labelWalletName.text = wallet.name
            if wallet.firstNumber >= 0 {
                self.labelTotalMoneyOfWallet.textColor = UIColor.blueColor()
                self.labelTotalMoneyOfWallet.text = "\(wallet.firstNumber) đ"
            } else {
                self.labelTotalMoneyOfWallet.textColor = UIColor.redColor()
                self.labelTotalMoneyOfWallet.text = "\(-wallet.firstNumber) đ"
            }
        }
    }
    
    func regisClassForCell() {
        tableView.registerClass(MenuViewControllerTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_MENU_TABLEVIEW_CELL)
        tableView.registerNib(UINib(nibName: IDENTIFIER_MENU_TABLEVIEW_CELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_MENU_TABLEVIEW_CELL)
    }
    // MARK: UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrViewControllers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_MENU_TABLEVIEW_CELL, forIndexPath:indexPath) as! MenuViewControllerTableViewCell
        let titleIndex = arrViewControllers[indexPath.row]
        cell.labelTitle?.text = titleIndex.title()
        cell.iamgeViewControlelr.image = UIImage(named: titleIndex.imageName())
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
                self.selectVC.view.frame = CGRectMake(0.0, 125.0, UIScreen.mainScreen().bounds.size.width - 100.0, UIScreen.mainScreen().bounds.size.height - 130.0)
            }) { Bool -> Void in
                self.addChildViewController(self.selectVC)
                self.selectVC.didMoveToParentViewController(self)
                self.view.addSubview(self.selectVC.view)
            }
            self.isShowSelectWallet = true
            self.buttonShowWalletList.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        } else {
            self.isShowSelectWallet = false
            if self.selectVC != nil {
                self.selectVC.removeFromParentViewController()
                self.selectVC.view.removeFromSuperview()
                self.selectVC = nil
                self.buttonShowWalletList.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
            }
        }
    }
}


extension TabPageViewController: RESideMenuDelegate {
    public override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func add(sender: AnyObject) {
//        let transaction = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
//        self.navigationController?.pushViewController(transaction, animated: true)
    }
}


