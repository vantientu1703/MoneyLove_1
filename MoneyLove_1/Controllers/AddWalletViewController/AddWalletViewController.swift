//
//  AddWalletViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

class AddWalletViewController: UIViewController {
    
    var walletItem: Wallet?
    @IBOutlet weak var buttonIcon: UIButton!
    @IBOutlet weak var txtStartMoneyWallet: UITextField!
    @IBOutlet weak var txtNameWallet: UITextField!
    @IBOutlet weak var buttonImageWallet: UIButton!
    @IBOutlet weak var labelNote: UILabel!
    var fetchedResultController: NSFetchedResultsController!
    let FILL_WALLET_NAME = "Fill wallet name,please!"
    let FILL_MONEY = "Fill amount money,please!"
    let IDENTIFIER_ICONMANAGER_VIEWCONTROLLER = "IconManagerViewController"
    let SELECT_IMAGE_WALLET = "Select image for wallet,please"
    var imageName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddWalletViewController.cancelButton(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddWalletViewController.addWalletButton(_:)))
        txtNameWallet.delegate = self
        txtStartMoneyWallet.delegate = self
        txtStartMoneyWallet.keyboardType = UIKeyboardType.NumberPad
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
        self.setWalletInfo()
    }
    
    func setWalletInfo() {
        if (txtNameWallet.text?.isEmpty)! {
            labelNote.text = FILL_WALLET_NAME
        } else if (txtStartMoneyWallet.text?.isEmpty)! {
            labelNote.text = FILL_MONEY
        } else if self.imageName.isEmpty {
            labelNote.text = SELECT_IMAGE_WALLET
        } else {
            walletItem = DataManager.shareInstance.addNewWallet(self.fetchedResultController)
            walletItem?.name = txtNameWallet.text
            walletItem?.firstNumber = Double(txtStartMoneyWallet.text!)!
            walletItem?.imageName = self.imageName
            DataManager.shareInstance.saveManagedObjectContext()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
        self.imageName = imageName
    }
}

extension AddWalletViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

