//
//  SearchExactlyMoneyOwner.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/26/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

protocol SearchExactlyMoneyDelegate: class {
    func delegateDoWhenSave(money: Int64)
    func delegateDoWhenCancel()
}

class SearchExactlyMoneyOwner: NSObject {
    @IBOutlet var exactView: SearchExactlyMoneyView!
}

class SearchExactlyMoneyView: UIView {
    weak var delegate: SearchExactlyMoneyDelegate!
    @IBOutlet var moneyTextField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBAction func clickToCancel(sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    @IBAction func clickToSave(sender: AnyObject) {
        let moneyStr = moneyTextField.text
        let arrayText = moneyStr!.componentsSeparatedByString(",")
        let newNumberText = arrayText.joinWithSeparator("")
        if let money = Int64(newNumberText) {
            delegate.delegateDoWhenSave(money)
        } else {
            delegate.delegateDoWhenSave(0)
        }
        self.removeFromSuperview()
    }
    
    class func presentInViewController(vc: SearchExactlyMoneyDelegate, caseType: MoneySearchType){
        let owner = SearchExactlyMoneyOwner()
        if let exactView = NSBundle.mainBundle().loadNibNamed("SearchExactlyMoneyView", owner: owner, options: nil).first as? SearchExactlyMoneyView {
            owner.exactView = exactView
            owner.exactView!.delegate = vc
            let dateType = caseType.title()
            owner.exactView.typeLabel.text = dateType
            owner.exactView.moneyTextField.delegate = owner.exactView
            owner.exactView.moneyTextField.addTarget(owner.exactView, action: #selector(SearchExactlyMoneyView.formatString(_:)), forControlEvents: UIControlEvents.EditingChanged)
            let vc = vc as? UIViewController
            if let vc = vc {
                owner.exactView!.frame = vc.view.bounds
                owner.exactView!.tag = 5
                vc.view.addSubview(owner.exactView!)
            }
        } else {
            print("Unable to load nib file Search Exactly Money View")
        }
    }
    func formatString(textField: UITextField) {
        let textArray = textField.text!.componentsSeparatedByString(",")
        let newText = textArray.joinWithSeparator("")
        let number = Int64(newText)
        let stringFormatted = number?.stringFormatedWithSepator
        textField.text = stringFormatted
    }
}

extension SearchExactlyMoneyView: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength = MAX_LENGTH_CHARACTER
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
}
