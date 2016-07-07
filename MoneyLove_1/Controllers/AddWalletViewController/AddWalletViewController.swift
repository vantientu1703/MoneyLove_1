//
//  AddWalletViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class AddWalletViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButton:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addWalletButton:")
    }
    
    func cancelButton(sender: AnyObject) {
        print("Cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addWalletButton(sender: AnyObject) {
        print("Add Wallet")
    }
}
