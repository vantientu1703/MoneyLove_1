//
//  AddWalletViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class AddWalletViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtStartMoneyWallet: UITextField!
    @IBOutlet weak var txtNameWallet: UITextField!
    @IBOutlet weak var buttonImageWallet: UIButton!
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
    @IBAction func pressButtonImageWallet(sender: AnyObject) {
    }
    
    @IBAction func hidenKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtNameWallet.resignFirstResponder()
        txtStartMoneyWallet.resignFirstResponder()
        return true
    }
}
