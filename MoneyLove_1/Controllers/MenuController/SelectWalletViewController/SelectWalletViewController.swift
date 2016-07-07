//
//  SelectWalletViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class SelectWalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let HEIGHT_SECTION0: CGFloat = 99
    let HEIGHT_SECTION1: CGFloat = 57
    let HEIGHT_SECTION2: CGFloat = 47
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.configRegisterForCell()
    }
    func configRegisterForCell() {
        tableView.registerClass(TotalMoneyTableViewCell.classForCoder(), forCellReuseIdentifier: "TotalMoneyTableViewCell")
        tableView.registerNib(UINib.init(nibName: "TotalMoneyTableViewCell", bundle: nil), forCellReuseIdentifier: "TotalMoneyTableViewCell")
        tableView.registerClass(WalletTableViewCell.classForCoder(), forCellReuseIdentifier: "WalletTableViewCell")
        tableView.registerNib(UINib.init(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletTableViewCell")
        tableView.registerClass(BottomTableViewCell.classForCoder(), forCellReuseIdentifier: "BottomTableViewCell")
        tableView.registerNib(UINib.init(nibName: "BottomTableViewCell", bundle: nil), forCellReuseIdentifier: "BottomTableViewCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 10
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let totalMoneyCell = tableView.dequeueReusableCellWithIdentifier("TotalMoneyTableViewCell", forIndexPath: indexPath)
            return totalMoneyCell
        } else if indexPath.section == 1 {
            let walletCell = tableView.dequeueReusableCellWithIdentifier("WalletTableViewCell", forIndexPath: indexPath)
            return walletCell
        } else {
            let bottomCell = tableView.dequeueReusableCellWithIdentifier("BottomTableViewCell", forIndexPath: indexPath) as! BottomTableViewCell
            if indexPath.row == 0 {
                bottomCell.labelAddWallet.text = "ADD WALLET"
            } else {
                bottomCell.labelAddWallet.text = "WALLET MANAGER"
            }
            return bottomCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HEIGHT_SECTION0
        } else if indexPath.section == 1 {
            return HEIGHT_SECTION1
        } else {
            return HEIGHT_SECTION2
        }
    }
    
    //MARK: UITableViewDelegate 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let addWalletVC = AddWalletViewController()
                let nav = UINavigationController(rootViewController: addWalletVC)
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
    }
}
