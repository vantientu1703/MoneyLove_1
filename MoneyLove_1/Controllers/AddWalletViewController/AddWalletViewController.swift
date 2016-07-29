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
    @IBOutlet weak var labelNote: UILabel!
    var statusEdit = ""
    var fetchedResultController: NSFetchedResultsController!
    let FILL_WALLET_NAME = "Fill wallet name,please!"
    let FILL_MONEY = "Fill amount money,please!"
    let IDENTIFIER_ICONMANAGER_VIEWCONTROLLER = "IconManagerViewController"
    let SELECT_IMAGE_WALLET = "Select image for wallet,please"
    var imageName = ""
    var stringA = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if statusEdit == WALLET_MANAGER_ISEMPTY {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: CANCEL_TITLE,style: UIBarButtonItemStyle.Plain,
                target: self,action: #selector(AddWalletViewController.checkAddNewWallet(_:)))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: CANCEL_TITLE,style: UIBarButtonItemStyle.Plain,
                target: self,action: #selector(AddWalletViewController.cancelButton(_:)))
        }
        if statusEdit == EDIT {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: DONE_TITLE,style: UIBarButtonItemStyle.Plain,
                target: self,action: #selector(AddWalletViewController.buttonEditWallet(_:)))
            self.imageName = self.walletItem!.imageName!
            self.buttonIcon.setImage(UIImage(named: self.imageName), forState: UIControlState.Normal)
            self.txtNameWallet.text = self.walletItem?.name
            self.txtStartMoneyWallet.text = "\(self.walletItem!.firstNumber)"
        } else {
            let rightButton = UIBarButtonItem(image: UIImage(named: IMAGE_BUTTON_ADD), style: UIBarButtonItemStyle.Plain,
                target: self, action: #selector(AddWalletViewController.addWalletButton(_:)))
            if let font = UIFont(name: "Arial", size: FONT_SIZE) {
                rightButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            }
            self.navigationItem.rightBarButtonItem = rightButton
        }
        txtNameWallet.delegate = self
        txtStartMoneyWallet.delegate = self
        txtStartMoneyWallet.addTarget(self, action: #selector(AddWalletViewController.formatString(_:)), forControlEvents: UIControlEvents.EditingChanged)
        txtStartMoneyWallet.keyboardType = UIKeyboardType.NumberPad
    }
    
    func formatString(textField: UITextField) {
        let textArray = textField.text!.componentsSeparatedByString(",")
        let newText = textArray.joinWithSeparator("")
        let number = Int64(newText)
        let stringFormatted = number?.stringFormatedWithSepator
        textField.text = stringFormatted
    }

    
    @IBAction func pressButtonIcon(sender: AnyObject) {
        let iconManagerVC = IconManagerViewController(nibName: IDENTIFIER_ICONMANAGER_VIEWCONTROLLER, bundle: nil)
        iconManagerVC.delegate = self
        self.navigationController?.pushViewController(iconManagerVC, animated: true)
    }
    func checkAddNewWallet(sender: AnyObject) {
        if let arrWallets = DataManager.shareInstance.getAllWallets() {
            let number = arrWallets.count
            if number == 0 {
                let alertControlelr = UIAlertController(title: REMINDER_TITLE,
                        message: MESSAGE_REMINDER, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: OK_TITLE, style: .Default, handler: nil)
                alertControlelr.addAction(okAction)
                self.presentViewController(alertControlelr, animated: true, completion: nil)
            }
        }
    }
    func buttonEditWallet(sender: AnyObject) {
        var pass = true
        if let name = txtNameWallet.text {
            if name.isEmpty {
                labelNote.text = FILL_WALLET_NAME
                pass = false
            }
        
        } else {
            pass = false
        }
        if let money = txtStartMoneyWallet.text {
            if money.isEmpty {
                labelNote.text = FILL_MONEY
                pass = false
            }
        } else {
            pass = false
        }
        if self.imageName.isEmpty {
            labelNote.text = SELECT_IMAGE_WALLET
            pass = false
        }
        if pass {
            let moneyStr = txtStartMoneyWallet.text
            let arrayText = moneyStr!.componentsSeparatedByString(",")
            let newNumberText = arrayText.joinWithSeparator("")
            walletItem?.name = txtNameWallet.text
            walletItem?.firstNumber = Int64(newNumberText)!
            walletItem?.imageName = self.imageName
            DataManager.shareInstance.saveManagedObjectContext()
            NSNotificationCenter.defaultCenter().postNotificationName(MESSAGE_ADD_NEW_TRANSACTION, object: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addWalletButton(sender: AnyObject) {
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
            if let arrWallets = DataManager.shareInstance.getAllWallets() {
                for wallet in arrWallets {
                    if wallet.name == self.txtNameWallet.text {
                        self.labelNote.text = WALLET_IS_EXISTED
                        return
                    }
                }
            }
            let walletItem = DataManager.shareInstance.addNewWallet(self.fetchedResultController)
            walletItem!.name = txtNameWallet.text
            let arrayText = txtStartMoneyWallet.text!.componentsSeparatedByString(",")
            let newNumberText = arrayText.joinWithSeparator("")
            walletItem!.firstNumber = Int64(newNumberText)!
            walletItem!.imageName = self.imageName
            DataManager.shareInstance.saveManagedObjectContext()
            if statusEdit == WALLET_MANAGER_ISEMPTY {
                DataManager.shareInstance.currentWallet = walletItem
                NSNotificationCenter.defaultCenter().postNotificationName(POST_CURRENT_WALLET, object: nil)
            }
            NSNotificationCenter.defaultCenter().postNotificationName(MESSAGE_ADD_NEW_TRANSACTION, object: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func hidenKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
}
extension AddWalletViewController: IconManagerViewControllerDelegate {
    func didSelectIconName(imageName: String) {
        self.buttonIcon.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        self.imageName = imageName
    }
}

extension AddWalletViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtNameWallet.resignFirstResponder()
        txtStartMoneyWallet.resignFirstResponder()
        return true
    }
}
