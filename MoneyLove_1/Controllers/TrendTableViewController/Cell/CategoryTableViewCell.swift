//
//  CategoryTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/27/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var nameTransaction: UILabel!
    @IBOutlet weak var totalMoney: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDateCategory(dic: [String: AnyObject]) {
        let name = dic["groupImage"] as! String
        imageCategory.image = UIImage(named: name)
        nameTransaction.text = "\(dic["groupName"] as! String)"
        totalMoney.text = "\(dic["totalMoney"] as! Int)"
    }
}
