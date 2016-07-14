//
//  TextCell.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
