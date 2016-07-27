//
//  ItemReportTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class ItemReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTransaction: UILabel!
    @IBOutlet weak var dateTransaction: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var imageTransaction: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataItem(dict: [String: AnyObject]) {
        totalMoney.text =  "\((dict["maxOfAmount"] as! Int).stringFormatedWithSepator)"
        nameTransaction.text = "\(dict["groupName"] as! String)"
        imageTransaction.image = UIImage(named: dict["groupImage"] as! String)
        dateTransaction.text = "\(dict["date"] as! String)"
    }
    
    func setDataDebtLoan(value: Int64, isDebt: Bool) {
        if isDebt {
            nameTransaction.text = "Debt"
            imageTransaction.image = UIImage(named: "grocery")
            totalMoney.text = "\(value.stringFormatedWithSepator)"
        } else {
            nameTransaction.text = "Loan"
            imageTransaction.image = UIImage(named: "photo")
            totalMoney.text = "\(value.stringFormatedWithSepator)"
        }
    }
    
    override func prepareForReuse() {
        imageTransaction.image = UIImage(named: "")
        nameTransaction.text = ""
        dateTransaction.text = ""
        totalMoney.text = ""
    }
    
}
