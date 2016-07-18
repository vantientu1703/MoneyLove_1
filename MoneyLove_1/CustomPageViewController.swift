//
//  CustomPageViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class CustomPageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([viewControllerAtIndex(0)], direction: .Forward, animated: true, completion: nil)
        self.didMoveToParentViewController(self)
        self.dataSource = self
        self.delegate = self
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        let allTransVC: AllTransactionViewController = AllTransactionViewController(nibName: "AllTransactionViewController", bundle: nil)
        allTransVC.index = index
        return allTransVC
    }
}

extension CustomPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let allTransVC = viewController as! AllTransactionViewController
        var index = allTransVC.index as Int
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let allTransVC = viewController as! AllTransactionViewController
        var index = allTransVC.index as Int
        index += 1
        return self.viewControllerAtIndex(index)
    }
}