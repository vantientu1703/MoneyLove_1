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
        self.contentViewShadowEnabled = true
        let customPageVC = CustomPageViewController()
        let menuVC = MenuViewController()
        if let arrWallets = DataManager.shareInstance.getAllWallets() {
            let number = arrWallets.count
            if number != 0 {
                let nav = UINavigationController(rootViewController:customPageVC)
                self.contentViewController = nav
            } else {
                let walletManagerVC = WalletManagerViewController()
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                walletManagerVC.managedObjectContext = appDelegate.managedObjectContext
                walletManagerVC.statusPush = WALLET_MANAGER_ISEMPTY
                let nav = UINavigationController(rootViewController:walletManagerVC)
                self.contentViewController = nav
            }
        }
        self.leftMenuViewController = menuVC
    }
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        print("This will show the menu")
    }
}
