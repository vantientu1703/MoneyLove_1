//
//  BalanceTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var openBalance: UILabel!
    @IBOutlet weak var endBalance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataBalance(open: Int, end: Int) {
        openBalance.text = open.stringFormatedWithSepator
        endBalance.text = end.stringFormatedWithSepator
    }
    
    override func prepareForReuse() {
        openBalance.text = "0"
        endBalance.text = "0"
    }
    
}
