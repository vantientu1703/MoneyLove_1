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
    @IBOutlet weak var moneyIcomeLabel: UILabel!
    @IBOutlet weak var moneyExpenseLabel: UILabel!
    
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
        moneyIcomeLabel.text = "\(money)"
    }
    
    func setDataTrendCellDefault(dataDic: Dictionary<String, AnyObject>) {
        let nameMonth = dataDic["monthString"] as! String
        let moneyIcome = dataDic["sumOfAmount"] as! Int
        monthLabel.text = nameMonth
        moneyIcomeLabel.text = "\(moneyIcome)"
        moneyExpenseLabel.hidden = true
    }
    
    func setDataTrendCellNetIncome(dataDic: Dictionary<String, AnyObject>) {
        moneyExpenseLabel.hidden = false
        let nameMonth = dataDic["monthString"] as! String
        let moneyIcome = dataDic["income"] as! Double
        let moneyExpense = dataDic["expense"] as! Double
        monthLabel.text = nameMonth
        moneyIcomeLabel.text = "\(moneyIcome)"
        moneyExpenseLabel.text = "\(moneyExpense)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //default state of cell
        moneyIcomeLabel.text = ""
        monthLabel.text = ""
    }
    
}
