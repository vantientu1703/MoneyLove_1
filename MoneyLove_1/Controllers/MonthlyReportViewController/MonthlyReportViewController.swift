//
//  MonthlyReportViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/13/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class MonthlyReportViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let NAME_VIEW = "MONTHLY REPORT"

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIBarButtonItem(image: UIImage(named: IMAGE_NAME_MENU), style: UIBarButtonItemStyle.Plain,
            target: self, action: #selector(MonthlyReportViewController.presentLeftMenuViewController(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        self.title = NAME_VIEW
        self.setViewControllers([viewControllerAtIndex(0)], direction: .Forward, animated: true, completion: nil)
        self.didMoveToParentViewController(self)
        self.dataSource = self
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        let itemReportVC: ItemReportViewController = ItemReportViewController()
        itemReportVC.pageIndex = index
        return itemReportVC
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let itemReportVC = viewController as! ItemReportViewController
        var index = itemReportVC.pageIndex as Int
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let itemReportVC = viewController as! ItemReportViewController
        var index = itemReportVC.pageIndex as Int
        index += 1
        if index > 0 {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
}

extension MonthlyReportViewController: RESideMenuDelegate {
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
}
