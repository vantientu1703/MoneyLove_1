//
//  DebtViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import TabPageViewController

class DebtViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabPageVC = TabPageViewController.create()
        let payableVC = UIViewController()
        payableVC.view.backgroundColor = UIColor.whiteColor()
        let receivableVC = PayReceiavableTableViewController(nibName: "PayReceiavableTableViewController", bundle: nil)
        tabPageVC.tabItems = [(payableVC, "Payable"), (receivableVC, "Receivable")]
        var option = TabPageOption()
        option.tabWidth = UIScreen.mainScreen().bounds.size.width / CGFloat(tabPageVC.tabItems.count)
        option.currentColor = UIColor.whiteColor()
        option.tabBackgroundColor = UIColor.greenColor()
        tabPageVC.option = option
        tabPageVC.title = "DEBTS"
        self.navigationController?.pushViewController(tabPageVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
