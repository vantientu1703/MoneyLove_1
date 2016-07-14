//
//  DateCell.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthAndYearLabel: UILabel!
      override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
