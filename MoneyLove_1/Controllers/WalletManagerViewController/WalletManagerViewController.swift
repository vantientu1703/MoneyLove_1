//
//  WalletManagerViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class WalletManagerViewController: UIViewController, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: "presentLeftMenuViewController:");
        self.configRegisterForCell()
        let addButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height - 30)
        addButton.backgroundColor = UIColor.greenColor()
        addButton.layer.cornerRadius = 20
        addButton.addTarget(self, action: "addWalletPress:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addButton)
    }
    
    func  addWalletPress(sender: AnyObject) {
        let addWallet = AddWalletViewController()
        let nav = UINavigationController(rootViewController: addWallet)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func configRegisterForCell() {
        tableView.registerClass(WalletManagerTableViewCell.classForCoder(), forCellReuseIdentifier: "WalletManagerTableViewCell")
        tableView.registerNib(UINib.init(nibName: "WalletManagerTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletManagerTableViewCell")
    }
        
    override func presentLeftMenuViewController(sender: AnyObject!) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let walletManagerCell = tableView.dequeueReusableCellWithIdentifier("WalletManagerTableViewCell", forIndexPath: indexPath)
        return walletManagerCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}
