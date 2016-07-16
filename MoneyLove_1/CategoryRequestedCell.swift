//
//  CategoryRequestedCell.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class CategoryRequestedCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var moneyNumberLabel: UILabel!
    var categoryName: String? {
        didSet {
            if let categoryName = categoryName {
                categoryNameLabel.text = categoryName
            } else {
                categoryNameLabel.text = ""
            }

        }
    }
    var imagePath: String? {
        didSet {
            if let imagePath = imagePath {
                let image = UIImage(named: imagePath)
                if let image = image {
                    categoryImageView.image = image
                } else {
                    categoryImageView.image = UIImage()
                }
            } else {
                categoryImageView.image = UIImage()
            }

        }
    }
    var moneyNumber: String {
        didSet {
            moneyNumberLabel.text = moneyNumber
        }
    }
    
    var color: UIColor {
        didSet {
            self.backgroundColor = color
        }
    }
    
    var moneyLabelTextColor: UIColor = UIColor.blackColor() {
        didSet {
            moneyNumberLabel.textColor = moneyLabelTextColor
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        moneyNumber = "0.000"
        color = UIColor.whiteColor()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        moneyNumber = "0.000"
        color = UIColor.whiteColor()
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func configureCell(indexPath: NSIndexPath, data: DataTransaction?, isHeader: Bool) {
        if isHeader {
            categoryName = data?.getHeaderTitleInIndexPath(indexPath.section)
            let money = data!.getSumOfAllMoneyInIndexPath(indexPath.section)
            if money < 0 {
                moneyLabelTextColor = UIColor.redColor()
            } else {
                moneyLabelTextColor = UIColor.blueColor()
            }
            moneyNumber = "\(money)"
            color = UIColor.lightGrayColor()
        } else {
            categoryName = data?.getCategoryNameForTransaction(indexPath)
            let money = data!.getMoneyNumberInIndexPath(indexPath)
            let type = data!.getCategoryTypeInIndexPath(indexPath)!
            if !type  {
                moneyLabelTextColor = UIColor.redColor()
            } else {
                moneyLabelTextColor = UIColor.blueColor()
            }
            moneyNumber =  "\(money)"
            imagePath = data?.getCategoryImageNameForTransaction(indexPath)
            color = UIColor.whiteColor()
        }
    }
}
