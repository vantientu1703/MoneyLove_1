//
//  OverViewCell.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class OverViewCell: UITableViewCell {

    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var netLabel: UILabel!
    var expense: String? {
        didSet {
            if let expense = expense {
                expenseLabel.text = expense
            } else {
                expenseLabel.text = "0.000"
            }
        }
    }

    var income: String? {
        didSet {
            if let income = income {
                incomeLabel.text = income
            } else {
                incomeLabel.text = "0.000"
            }
        }
    }

    var net: String? {
        didSet {
            if let net = net {
                netLabel.text = net
            } else {
                netLabel.text = "0.000"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(data: DataTransaction?) {
        let result = data!.getSumOfAllExpenseAndIncome()
        expense = result.0.stringFormatedWithSepator
        income = result.1.stringFormatedWithSepator
        let netNumber = result.1 - result.0
        if netNumber < 0 {
            netLabel.textColor = UIColor.redColor()
        } else {
            netLabel.textColor = UIColor.blueColor()
        }
        net = netNumber.stringFormatedWithSepator
        if result.0 + result.1 == 0 {
            self.hidden = true
        } else {
            self.hidden = false
        }
    }
}
