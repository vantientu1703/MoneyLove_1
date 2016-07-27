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
    func customDateViewDoWhenCancel()
}

class CustomDateViewOwner: NSObject {
    @IBOutlet var customDateView: CustomDateView!
}

class CustomDateView: UIView {
    weak var delegate: CustomDateViewDelegate!
    @IBOutlet weak var startingDate: UILabel!
    @IBOutlet weak var endingDate: UILabel!
    var start: NSDate = NSDate.startOfDay(NSDate()) {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            startingDate.text = dateFormatter.stringFromDate(start)
        }
    }
    var end :NSDate = NSDate.endOfDay(NSDate()) {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            endingDate.text = dateFormatter.stringFromDate(end)
        }
    }
    class func presentInViewController(viewController: CustomDateViewDelegate) {
        let owner = CustomDateViewOwner()
        if let customDateView = NSBundle.mainBundle().loadNibNamed("CustomDateView", owner: owner, options: nil).first as? CustomDateView {
            owner.customDateView = customDateView
            owner.customDateView!.delegate = viewController
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let startDateStr = dateFormatter.stringFromDate(owner.customDateView!.start)
            let endDateStr = dateFormatter.stringFromDate(owner.customDateView!.end)
            customDateView.startingDate.text = startDateStr
            customDateView.endingDate.text = endDateStr
            let tapGestureOfStartingDate = UITapGestureRecognizer(target: owner.customDateView, action: #selector(CustomDateView.clickToShowCalendar(_:)))
            let tapGestureOfEndingDate = UITapGestureRecognizer(target: owner.customDateView, action: #selector(CustomDateView.clickToShowCalendar(_:)))
            owner.customDateView!.startingDate.addGestureRecognizer(tapGestureOfStartingDate)
            owner.customDateView!.endingDate.addGestureRecognizer(tapGestureOfEndingDate)
            let vc = viewController as? UIViewController
            if let vc = vc {
                owner.customDateView!.frame = vc.view.bounds
                owner.customDateView!.tag = 5
                vc.view.addSubview(owner.customDateView!)
            }
        }
    }
    
    func clickToShowCalendar(gesture: UITapGestureRecognizer) {
        let label = gesture.view as! UILabel
        delegate.delegateDoWhenShowCalendarVC(label)
    }
    
    @IBAction func clickToSave(sender: AnyObject) {
        delegate.delegateDoWhenSave(start, endingDate: end)
        self.removeFromSuperview()
    }
    @IBAction func clickToCancel(sender: AnyObject) {
        delegate.customDateViewDoWhenCancel()
    }
}
