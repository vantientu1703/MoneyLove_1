//
//  ActionTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
    var actionHandler: ((nameAction: String) -> Void)!
    @IBOutlet weak var btnDateFrom: UIButton!
    @IBOutlet weak var btnDateTo: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func dateFromAction(sender: AnyObject) {
        actionHandler(nameAction: "From")
    }
    
    @IBAction func dateToAction(sender: AnyObject) {
        actionHandler(nameAction: "To")
    }
}
