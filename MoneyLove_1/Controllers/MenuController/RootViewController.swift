//
//  RootViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class RootViewController: RESideMenu, RESideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor();
        self.contentViewShadowOffset = CGSizeMake(0, 0);
        self.contentViewShadowOpacity = 0.6;
        self.contentViewShadowRadius = 12;
        self.contentViewShadowEnabled = true;
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryVC = CategoriesViewController()
        categoryVC.managedObjectContext = appDelegate.managedObjectContext
        let menuVC = MenuViewController()
        let nav = UINavigationController(rootViewController: categoryVC)
        self.contentViewController = nav
        self.leftMenuViewController = menuVC
    }
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        print("This will show the menu")
    }
}
