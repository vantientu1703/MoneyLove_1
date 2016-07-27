//
//  PieChartCategoryTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/27/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import Charts

class PieChartCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var pieChartCategory: PieChartView!
    var dataEntries: [ChartDataEntry]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: CHARTBYCATERGORY
    func setDataCharCategory(data: [Dictionary<String, AnyObject>]) {
        var groupName = [String]()
        var value = [Double]()
        for dic in data {
            let name = dic["groupName"] as! String
            let totalMoney = dic["totalMoney"] as! Double
            groupName.append(name)
            value.append(totalMoney)
        }
        setChart(groupName, values: value)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        dataEntries = []
        for (index, value) in values.enumerate() {
            let dataEntry = ChartDataEntry(value: value, xIndex: index)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartCategory.data = pieChartData
        var colors = [UIColor]()
        for _ in 0..<dataPoints.count {
            let colorRandom = UIColor.getRandomColor()
            colors.append(colorRandom)
        }
        pieChartDataSet.colors = colors
    }
}
