//
//  SearchMoneySelectOwner.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/26/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
protocol SearchMoneySelectDelegate: class {
    func searchMoneyDoWhenSave(from: Double, to: Double)
    func searchMoneyDoWhenCancel()
}
class SearchMoneySelectOwner: NSObject {
    var moneyRangeView: SearchMoneySelectView?

}

class SearchMoneySelectView: UIView {
    var moneyNumberFrom: Double!
    var moneyNumberTo: Double!
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
            if let from = Double(textFrom) {
                moneyNumberFrom = from
            } else {
                moneyNumberFrom = 0.0
            }
        } else {
            moneyNumberFrom = 0.0
        }
        if let textTo = moneyTo.text {
            if let numberTo = Double(textTo) {
                moneyNumberTo = numberTo
            } else {
                moneyNumberTo = 0.0
            }
        } else {
            moneyNumberTo = 0.0
        }
    }
    
    class func presentInViewController(vc: SearchMoneySelectDelegate) {
        let owner = SearchMoneySelectOwner()
        if let moneySelectView = NSBundle.mainBundle().loadNibNamed("SearchMoneySelectView", owner: owner, options: nil).first as? SearchMoneySelectView {
            owner.moneyRangeView = moneySelectView
            owner.moneyRangeView!.delegate = vc
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

