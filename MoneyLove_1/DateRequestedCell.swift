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
                moneyNumberLAbel.text = "0.0"
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
    var color: UIColor =  UIColor.whiteColor() {
        didSet {
            self.backgroundColor = color
            containerView.backgroundColor = color
        }
    }

    var moneyLabelTextColor: UIColor = UIColor.blackColor() {
        didSet {
            if let moneyNumberLAbel = moneyNumberLAbel {
                moneyNumberLAbel.textColor = moneyLabelTextColor
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(indexPath: NSIndexPath, data: DataTransaction?, isHeader: Bool) {
        if isHeader {
            var sum = data?.getSumOfAllMoneyInIndexPath(indexPath.section)
            let stringOfDate = data?.getHeaderTitleInIndexPath(indexPath.section)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.dateFromString(stringOfDate!)
            let dateComponents = stringOfDate?.componentsSeparatedByString("-")
            dateStr = dateComponents![0]
            monthAndYear = dateComponents![1] + " - " + dateComponents![2]
            weekDay = NSDate.dayOfTheWeek(date!)
            if sum < 0 {
                moneyLabelTextColor = UIColor.redColor()
                sum = sum! * -1
            } else {
                moneyLabelTextColor = UIColor.blueColor()
            }
            color = UIColor.lightGrayColor()
            money = "\(sum!)"
        } else {
            let stringOfDate = data?.getTimeForTransaction(indexPath)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = dateFormatter.dateFromString(stringOfDate!)
            let dateComponents = stringOfDate?.componentsSeparatedByString("-")
            dateStr = dateComponents![0]
            monthAndYear = dateComponents![1] + " - " + dateComponents![2]
            weekDay = NSDate.dayOfTheWeek(date!)
            var moneyNumber = data!.getMoneyNumberInIndexPath(indexPath)
            if moneyNumber < 0 {
                moneyLabelTextColor = UIColor.redColor()
                moneyNumber = moneyNumber * -1
            } else {
                moneyLabelTextColor = UIColor.blueColor()
            }
            money = "\(moneyNumber)"
            color = UIColor.whiteColor()
        }
    }
}
