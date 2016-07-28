//
//  SearchMoneySelectOwner.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/26/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
protocol SearchMoneySelectDelegate: class {
    func searchMoneyDoWhenSave(from: Int64, to: Int64)
    func searchMoneyDoWhenCancel()
}
class SearchMoneySelectOwner: NSObject {
    @IBOutlet var moneyRangeView: SearchMoneySelectView!
    
    func formatString(textField: UITextField) {
        let textArray = textField.text!.componentsSeparatedByString(",")
        let newText = textArray.joinWithSeparator("")
        let number = Int64(newText)
        let stringFormatted = number?.stringFormatedWithSepator
        textField.text = stringFormatted
    }
}

class SearchMoneySelectView: UIView {
    var moneyNumberFrom: Int64!
    var moneyNumberTo: Int64!
    weak var delegate: SearchMoneySelectDelegate!
    @IBOutlet weak var moneyFrom: UITextField!
    @IBOutlet weak var moneyTo: UITextField!
    @IBAction func clickToCancel(sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    @IBAction func clickToSave(sender: AnyObject) {
        self.getTextFromTextField()
        delegate.searchMoneyDoWhenSave(moneyNumberFrom, to: moneyNumberTo)
        self.removeFromSuperview()
    }
    
    func getTextFromTextField() {
        if let textFrom = moneyFrom.text {
            if let from = Int64(textFrom) {
                moneyNumberFrom = from
            } else {
                moneyNumberFrom = 0
            }
        } else {
            moneyNumberFrom = 0
        }
        if let textTo = moneyTo.text {
            if let numberTo = Int64(textTo) {
                moneyNumberTo = numberTo
            } else {
                moneyNumberTo = 0
            }
        } else {
            moneyNumberTo = 0
        }
    }
    
    class func presentInViewController(vc: SearchMoneySelectDelegate) {
        let owner = SearchMoneySelectOwner()
        if let moneySelectView = NSBundle.mainBundle().loadNibNamed("SearchMoneySelectView", owner: owner, options: nil).first as? SearchMoneySelectView {
            owner.moneyRangeView = moneySelectView
            owner.moneyRangeView!.delegate = vc
            owner.moneyRangeView.moneyFrom.addTarget(owner, action: #selector(SearchMoneySelectOwner.formatString(_:)), forControlEvents: UIControlEvents.EditingChanged)
            owner.moneyRangeView.moneyTo.addTarget(owner, action: #selector(SearchMoneySelectOwner.formatString(_:)), forControlEvents: UIControlEvents.EditingChanged)
            let vc = vc as? UIViewController
            if let vc = vc {
                owner.moneyRangeView!.frame = vc.view.bounds
                owner.moneyRangeView!.tag = 6
                vc.view.addSubview(owner.moneyRangeView!)
            }
        } else {
            print("Unable to load nib file Search Exactly Money View")
        }
    }
}

