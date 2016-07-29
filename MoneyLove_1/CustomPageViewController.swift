//
//  CustomPageViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData
class CustomPageViewController: UIPageViewController {
    var isCategoryMode: Bool! = false
    var timeMode:TimeMode! = .Day
        override func viewDidLoad() {
        super.viewDidLoad()
        let title = DataManager.shareInstance.currentWallet.name
        self.title = title
        self.setViewControllers([viewControllerAtIndex(0)], direction: .Forward, animated: true, completion: nil)
        self.didMoveToParentViewController(self)
        self.dataSource = self
        self.delegate = self
        self.configureNavigationBar()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeWallet(_:)), name: "changeWallet", object: nil)

    }
    
    func changeWallet(notifcation: NSNotification) {
        title = DataManager.shareInstance.currentWallet.name
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        let allTransVC: AllTransactionViewController = AllTransactionViewController(nibName: "AllTransactionViewController", bundle: nil)
        allTransVC.index = index
        allTransVC.isCategoryMode = isCategoryMode
        allTransVC.timeMode = timeMode
        return allTransVC
    }
    
    func getCurrentViewController() -> AllTransactionViewController? {
        if self.viewControllers?.count > 0 {
            let currentVC = self.viewControllers![0] as! AllTransactionViewController
            return currentVC
        }
        return nil
    }
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    func configureNavigationBar() {
        let leftButton = UIBarButtonItem(image: UIImage(named: IMAGE_NAME_MENU), style: UIBarButtonItemStyle.Plain,
            target: self.getCurrentViewController(), action: #selector(AllTransactionViewController.presentLeftMenuViewController(_:)))
        let rightButton = UIBarButtonItem(image: UIImage(named: IMAGE_THREE_DOTS), style: UIBarButtonItemStyle.Plain,
            target: self.getCurrentViewController(), action: #selector(AllTransactionViewController.clickToChangeMode(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        title = DataManager.shareInstance.currentWallet.name
    }
}

extension CustomPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let allTransVC = viewController as! AllTransactionViewController
        var index = allTransVC.index as Int
        index -= 1
        isCategoryMode = allTransVC.isCategoryMode
        timeMode = allTransVC.timeMode
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let allTransVC = viewController as! AllTransactionViewController
        var index = allTransVC.index as Int
        index += 1
        isCategoryMode = allTransVC.isCategoryMode
        timeMode = allTransVC.timeMode
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.configureNavigationBar()
    }
}

