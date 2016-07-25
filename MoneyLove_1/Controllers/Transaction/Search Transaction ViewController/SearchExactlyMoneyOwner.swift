//
//  SearchExactlyMoneyOwner.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/26/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

protocol SearchExactlyMoneyDelegate: class {
    func delegateDoWhenSave(money: Double)
    func delegateDoWhenCancel()
}

class SearchExactlyMoneyOwner: NSObject {

    var exactView: SearchExactlyMoneyView?
}

class SearchExactlyMoneyView: UIView {
    weak var delegate: SearchExactlyMoneyDelegate!
    @IBOutlet var moneyTextField: UITextField!
    @IBAction func clickToCancel(sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    @IBAction func clickToSave(sender: AnyObject) {
        let moneyStr = moneyTextField.text
        if let money = Double(moneyStr!) {
            delegate.delegateDoWhenSave(money)
        } else {
            delegate.delegateDoWhenSave(0.0)
        }
        self.removeFromSuperview()
    }
    
    class func presentInViewController(vc: SearchExactlyMoneyDelegate){
        let owner = SearchExactlyMoneyOwner()
        if let exactView = NSBundle.mainBundle().loadNibNamed("SearchExactlyMoneyView", owner: owner, options: nil).first as? SearchExactlyMoneyView {
            owner.exactView = exactView
            owner.exactView!.delegate = vc
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
}