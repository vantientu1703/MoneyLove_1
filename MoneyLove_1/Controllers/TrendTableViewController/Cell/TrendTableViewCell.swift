//
//  TrendTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class TrendTableViewCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataTrendCell(month: String, money: Double) {
        monthLabel.text = month
        moneyLabel.text = "\(money)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //default state of cell
        moneyLabel.text = ""
        monthLabel.text = ""
    }
    
}
