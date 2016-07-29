//
//  SearchOverViewCell.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/26/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class SearchOverViewCell: UITableViewCell {

    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!

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

    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    func configureCell(data: DataResultTransaction?) {
        let result = data!.getSumOfAllExpenseAndIncome()
        expense = "\(result.0)"
        income = "\(result.1)"
        if result.0 + result.1 == 0 {
            self.hidden = true
        } else {
            self.hidden = false
        }
    }
    
}
