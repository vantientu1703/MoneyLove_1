//
//  WalletManagerViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class WalletManagerViewController: UIViewController, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let IDENTIFIER_WALLET_MANAGER = "WalletManagerTableViewCell"
    let TITLE_WALLET_MANAGER = "Wallet Manager"
    let TITLE_BUTTON_LEFT = "Left"
    let HEIHT_CELL_WALLETMANAGER: CGFloat = 60.0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonWallet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TITLE_WALLET_MANAGER
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: TITLE_BUTTON_LEFT, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WalletManagerViewController.cancelButton(_:)));
        self.configRegisterForCell()
        addButtonWallet.layer.cornerRadius = 20.0
    }
    
    @IBAction func  addWalletPress(sender: AnyObject) {
        let addWallet = AddWalletViewController()
        let nav = UINavigationController(rootViewController: addWallet)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func configRegisterForCell() {
        tableView.registerClass(WalletManagerTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_WALLET_MANAGER)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_WALLET_MANAGER, bundle: nil), forCellReuseIdentifier: IDENTIFIER_WALLET_MANAGER)
    }
        
    func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UITableViewDataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let walletManagerCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_WALLET_MANAGER, forIndexPath: indexPath)
        return walletManagerCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIHT_CELL_WALLETMANAGER
    }
}
