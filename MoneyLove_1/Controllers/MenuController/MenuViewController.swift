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

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let HEIGHT_CELL_SECTION1: CGFloat = 60
    let HEIGHT_CELL_SECTION2: CGFloat = 70
    let HEIGHT_CELL_SECTION3: CGFloat = 44
    weak var delegate: MenuViewControllerDelegate?
    var selectVC: SelectWalletViewController!
    var isShowSelectWallet: Bool?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonShowWalletList: UIButton!
    let arrTitle: Array = ["Transactions", "Debts", "Trends", "Monthly Report", "Categories"]
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
        return arrTitle.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CellDefault"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath:indexPath)
        cell.textLabel?.text = arrTitle[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
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
    //MARK: ShowWalletListTableViewCellDelegate
    func showWalletController() {
        print("Press button delegate")
    }
    
    @IBAction func pressSelectWalletFromView(sender: AnyObject) {
        self.initSelectWalletViewController()
    }
    @IBAction func pressSelectWallet(sender: AnyObject) {
        self.initSelectWalletViewController()
    }
    //MARK init SelectWalletViewController
    func initSelectWalletViewController() {
        if self.isShowSelectWallet == false {
            selectVC = SelectWalletViewController()
            selectVC.view.frame = CGRectMake(0, 130, UIScreen.mainScreen().bounds.size.width - 100, 0)
            UIView.animateWithDuration(10, animations: { () -> Void in
                self.selectVC.view.frame = CGRectMake(0, 130, UIScreen.mainScreen().bounds.size.width - 100, UIScreen.mainScreen().bounds.size.height - 130)
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
