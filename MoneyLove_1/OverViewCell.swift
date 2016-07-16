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
    var color: UIColor {
        didSet {
            self.backgroundColor = UIColor.darkGrayColor()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        color = UIColor.whiteColor()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        color = UIColor.whiteColor()
        super.init(coder: aDecoder)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(data: DataTransaction?) {
        let result = data!.getSumOfAllExpenseAndIncome()
        expense = "\(result.0)"
        income = "\(result.1)"
        net = "\(abs(result.0 - result.1))"
        color = UIColor.lightGrayColor()
    }
}
