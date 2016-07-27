//
//  LabelCell.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/27/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabelCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
