//
//  PageReportViewController.swift
//  MoneyLove_1
//
//  Created by framgia on 7/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class PageReportViewController: UIViewController {
    
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.presentLeftMenuViewController(_:)))
        let pageViewVC = MyPageViewController()
        self.addChildViewController(pageViewVC)
        self.view.addSubview((pageViewVC.view))
        pageViewController = pageViewVC as UIPageViewController
        pageViewController.dataSource = self
        pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: .Forward, animated: true, completion: nil)
        pageViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        pageViewController.view.frame = self.view.frame
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        let itemReportVC: ItemReportViewController = ItemReportViewController()
        itemReportVC.pageIndex = index
        return itemReportVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PageReportViewController: UIPageViewControllerDataSource {
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
        return self.viewControllerAtIndex(index)
    }
}

extension PageReportViewController: RESideMenuDelegate {
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
}
