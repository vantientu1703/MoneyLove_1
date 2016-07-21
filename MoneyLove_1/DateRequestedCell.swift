//
//  DateRequestedCell.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class DateRequestedCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var monthAndYearLabel: UILabel!
    @IBOutlet weak var moneyNumberLAbel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var money: String? {
        didSet {
            if let money = money {
                moneyNumberLAbel.text = money
            } else {
                moneyNumberLAbel.text = "0.000"
            }
        }
    }
    var dateStr: String? {
        didSet {
            if let date = dateStr {
                dateLabel.text = date
            } else {
                dateLabel.text = ""
            }
        }
    }
    var monthAndYear: String? {
        didSet {
            if let monthAndYear = monthAndYear {
                monthAndYearLabel.text = monthAndYear
            } else {
                monthAndYearLabel.text = ""
            }
        }
    }
    var weekDay: String? {
        didSet {
            if let weekDay = weekDay {
                weekDayLabel.text = weekDay
            } else {
                weekDayLabel.text = ""
            }
        }
    }
    var color : UIColor {
        didSet {
            self.backgroundColor = color
            containerView.backgroundColor = color
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        color = UIColor.whiteColor()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(indexPath: NSIndexPath, data: DataTransaction?, isHeader: Bool) {
        if isHeader {
            let sum = data?.getSumOfAllMoneyInIndexPath(indexPath.section)
            dateStr = data?.getHeaderTitleInIndexPath(indexPath.section)
            money = "\(sum!)"
            color = UIColor.lightGrayColor()
        } else {
            dateStr = data?.getTimeForTransaction(indexPath)
            money = "\(data?.getMoneyNumberInIndexPath(indexPath))"
            color = UIColor.whiteColor()
        }
    }
}
