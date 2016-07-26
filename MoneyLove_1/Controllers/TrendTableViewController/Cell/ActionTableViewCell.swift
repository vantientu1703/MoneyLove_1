//
//  ActionTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

enum SegmentGroupType: Int {
    case Expense
    case Income
    case NetIncome
}

enum SegmentGroupByTrend: Int {
    case OverTime
    case Category
}

enum SelectDate {
    case FromDate
    case ToDate
}

class ActionTableViewCell: UITableViewCell {
    
    var handlerSelectDate: ((date: SelectDate) -> Void)!
    var handerSelectSegment: ((groupType: SegmentGroupType, groupByTrend: SegmentGroupByTrend) ->Void)!
    @IBOutlet weak var btnDateFrom: UIButton!
    @IBOutlet weak var btnDateTo: UIButton!
    @IBOutlet weak var segmentGroupType: UISegmentedControl!
    @IBOutlet weak var segmentGroupBy: UISegmentedControl!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func dateFromAction(sender: AnyObject) {
        handlerSelectDate(date: SelectDate.FromDate)
    }
    
    @IBAction func dateToAction(sender: AnyObject) {
        handlerSelectDate(date: SelectDate.ToDate)
    }
    
    @IBAction func segmentGroupTypeAction(sender: AnyObject) {
        processSegmentAction ()
    }
    
    @IBAction func segmentGroupByAction(sender: AnyObject) {
        processSegmentAction ()
    }
    
    func processSegmentAction () {
        if segmentGroupType.selectedSegmentIndex == SegmentGroupType.Expense.rawValue && segmentGroupBy.selectedSegmentIndex == SegmentGroupByTrend.OverTime.rawValue {
            handerSelectSegment(groupType: SegmentGroupType.Expense, groupByTrend: SegmentGroupByTrend.OverTime)
        }
        
        if segmentGroupType.selectedSegmentIndex == SegmentGroupType.Expense.rawValue && segmentGroupBy.selectedSegmentIndex == SegmentGroupByTrend.Category.rawValue {
            handerSelectSegment(groupType: SegmentGroupType.Expense, groupByTrend: SegmentGroupByTrend.Category)
        }
        
        if segmentGroupType.selectedSegmentIndex == SegmentGroupType.Income.rawValue && segmentGroupBy.selectedSegmentIndex == SegmentGroupByTrend.OverTime.rawValue {
            handerSelectSegment(groupType: SegmentGroupType.Income, groupByTrend: SegmentGroupByTrend.OverTime)
        }
        
        if segmentGroupType.selectedSegmentIndex == SegmentGroupType.Income.rawValue && segmentGroupBy.selectedSegmentIndex == SegmentGroupByTrend.Category.rawValue {
            handerSelectSegment(groupType: SegmentGroupType.Income, groupByTrend: SegmentGroupByTrend.Category)
        }
        
        if segmentGroupType.selectedSegmentIndex == SegmentGroupType.NetIncome.rawValue {
            segmentGroupBy.selectedSegmentIndex = -1
            handerSelectSegment(groupType: SegmentGroupType.NetIncome, groupByTrend: SegmentGroupByTrend.OverTime)
        }
    }
}
