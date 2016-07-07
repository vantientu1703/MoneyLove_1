//
//  CategoriesViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, RESideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        self.view.backgroundColor = UIColor.grayColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: "presentLeftMenuViewController:")
    }
    
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
}
