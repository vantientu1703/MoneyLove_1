//
//  AddWalletViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class AddWalletViewController: UIViewController {

    @IBOutlet weak var buttonIcon: UIButton!
    @IBOutlet weak var txtStartMoneyWallet: UITextField!
    @IBOutlet weak var txtNameWallet: UITextField!
    @IBOutlet weak var buttonImageWallet: UIButton!
    let IDENTIFIER_ICONMANAGER_VIEWCONTROLLER = "IconManagerViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddWalletViewController.cancelButton(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddWalletViewController.addWalletButton(_:)))
        txtNameWallet.delegate = self
        txtStartMoneyWallet.delegate = self
    }
    
    @IBAction func pressButtonIcon(sender: AnyObject) {
        let iconManagerVC = IconManagerViewController(nibName: IDENTIFIER_ICONMANAGER_VIEWCONTROLLER, bundle: nil)
        iconManagerVC.delegate = self
        self.navigationController?.pushViewController(iconManagerVC, animated: true)
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
extension AddWalletViewController: IconManagerViewControllerDelegate {
    func didSelectIconName(imageName: String) {
        self.buttonIcon.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    }
}

extension AddWalletViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

