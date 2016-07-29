//
//  PayReceiavableTableView.swift
//  MoneyLove_1
//
//  Created by framgia on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class PayReceiavableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameDebts: UILabel!
    @IBOutlet weak var numberTransaction: UILabel!
    @IBOutlet weak var totalDebts: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataPayReceiavableCell(tran: Transaction, color: UIColor?) {
        if tran.personRelated != "" {
            nameDebts.text = tran.personRelated
        } else {
            nameDebts.text = "Someone"
        }
        numberTransaction.text = NSDate.convertTimeIntervalToDateString(tran.date)
        totalDebts.text = "\(Int64(tran.moneyNumber).stringFormatedWithSepator)"
        if (color != nil) {
            totalDebts.textColor = color
        }
    }
    
}
