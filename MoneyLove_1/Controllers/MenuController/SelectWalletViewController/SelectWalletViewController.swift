//
//  SelectWalletViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

enum IndexPathSection: Int {
    case Section_TotalMoney
    case Section_Wallet
    case Section_Bottom
}
class SelectWalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let HEIGHT_SECTION0: CGFloat = 99.0
    let HEIGHT_SECTION1: CGFloat = 57.0
    let HEIGHT_SECTION2: CGFloat = 47.0
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
        switch section {
            case IndexPathSection.Section_TotalMoney.rawValue:
                return 1
            case IndexPathSection.Section_Wallet.rawValue:
                return 10
            case IndexPathSection.Section_Bottom.rawValue:
                return 2
            default:
                return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
            case IndexPathSection.Section_TotalMoney.rawValue:
                let totalMoneyCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_TOTALMONEYTABLEVIEWCELL, forIndexPath: indexPath)
                return totalMoneyCell
            case IndexPathSection.Section_Wallet.rawValue:
                let walletCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_WALETTTABLEVIEWCELL, forIndexPath: indexPath)
                return walletCell
            case IndexPathSection.Section_Bottom.rawValue:
                let bottomCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_BOTTOMTABLEVIEWCELL, forIndexPath: indexPath) as! BottomTableViewCell
                if indexPath.row == 0 {
                    bottomCell.labelAddWallet.text = TITLE_ADD_WALLET
                } else {
                    bottomCell.labelAddWallet.text = TITLE_WALLET_MANAGER
                }
                return bottomCell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
            case IndexPathSection.Section_TotalMoney.rawValue:
               return HEIGHT_SECTION0
            case IndexPathSection.Section_Wallet.rawValue:
                return HEIGHT_SECTION1
            case IndexPathSection.Section_Bottom.rawValue:
                return HEIGHT_SECTION2
            default:
                return CGFloat(-1.0)
        }
    }
    
    //MARK: UITableViewDelagate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == IndexPathSection.Section_Bottom.rawValue {
            if indexPath.row == 0 {
                let addWalletVC = AddWalletViewController()
                let nav = UINavigationController(rootViewController: addWalletVC)
                self.presentViewController(nav, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                let walletManagerVC = WalletManagerViewController()
                let nav = UINavigationController(rootViewController: walletManagerVC)
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
    }
    
}
