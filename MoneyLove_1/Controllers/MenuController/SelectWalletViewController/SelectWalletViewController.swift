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
    let IDENTIFIER_TOTALMONEYTABLEVIEWCELL = "TotalMoneyTableViewCell"
    let IDENTIFIER_WALETTTABLEVIEWCELL = "WalletTableViewCell"
    let IDENTIFIER_BOTTOMTABLEVIEWCELL = "BottomTableViewCell"
    let TITLE_ADD_WALLET = "ADD WALLET"
    let TITLE_WALLET_MANAGER = "WALLET MANAGER"
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configRegisterForCell()
    }
    func configRegisterForCell() {
        tableView.registerClass(TotalMoneyTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_TOTALMONEYTABLEVIEWCELL)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_TOTALMONEYTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_TOTALMONEYTABLEVIEWCELL)
        tableView.registerClass(WalletTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_WALETTTABLEVIEWCELL)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_WALETTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_WALETTTABLEVIEWCELL)
        tableView.registerClass(BottomTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_BOTTOMTABLEVIEWCELL)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_BOTTOMTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_BOTTOMTABLEVIEWCELL)
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
            let totalMoneyCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_TOTALMONEYTABLEVIEWCELL, forIndexPath: indexPath)
            return totalMoneyCell
        } else if indexPath.section == 1 {
            let walletCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_WALETTTABLEVIEWCELL, forIndexPath: indexPath)
            return walletCell
        } else {
            let bottomCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_BOTTOMTABLEVIEWCELL, forIndexPath: indexPath) as! BottomTableViewCell
            if indexPath.row == 0 {
                bottomCell.labelAddWallet.text = TITLE_ADD_WALLET
            } else {
                bottomCell.labelAddWallet.text = TITLE_WALLET_MANAGER
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
    
    //MARK: UITableViewDelagate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let addWalletVC = AddWalletViewController()
                let nav = UINavigationController(rootViewController: addWalletVC)
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
    }
    
}
