//
//  CustomDateViewOwner.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
protocol CustomDateViewDelegate: class {
    func delegateDoWhenSave(startingDate: NSDate, endingDate: NSDate)
    func delegateDoWhenShowCalendarVC(label: UILabel)
}

class CustomDateViewOwner: NSObject {
    @IBOutlet var customDateView: CustomDateView!
}

class CustomDateView: UIView {
    weak var delegate: CustomDateViewDelegate!
    @IBOutlet weak var startingDate: UILabel!
    @IBOutlet weak var endingDate: UILabel!
    var start: NSDate? {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let start = start {
                startingDate.text = dateFormatter.stringFromDate(start)
            }
        }
    }
    var end :NSDate? {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let end = end {
                endingDate.text = dateFormatter.stringFromDate(end)
            }
        }
    }
    class func presentInViewController(viewController: CustomDateViewDelegate) {
        let owner = CustomDateViewOwner()
        NSBundle.mainBundle().loadNibNamed("CustomDateView", owner: owner, options: nil)
        owner.customDateView.delegate = viewController
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomDateView.clickToShowCalendar(_:)))
        owner.customDateView.startingDate.addGestureRecognizer(tapGesture)
        owner.customDateView.endingDate.addGestureRecognizer(tapGesture)
        let vc = viewController as? AllTransactionViewController
        if let vc = vc {
            owner.customDateView.frame = vc.view.bounds
            vc.view.addSubview(owner.customDateView)
        }
    }
    
    func clickToShowCalendar(gesture: UITapGestureRecognizer) {
        let label = gesture.view as! UILabel
        delegate.delegateDoWhenShowCalendarVC(label)
    }
    
    @IBAction func clickToSave(sender: AnyObject) {
        delegate.delegateDoWhenSave(start!, endingDate: end!)
        self.removeFromSuperview()
    }
    @IBAction func clickToCancel(sender: AnyObject) {
        self.removeFromSuperview()
    }
}
