//
//  BottomTableViewCell.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class BottomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewBottom: UIImageView!
    
    
    @IBOutlet weak var labelAddWallet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
