//
//  PieChartTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import Charts

class PieChartTableViewCell: UITableViewCell {

    @IBOutlet weak var pieChartView: PieChartView!
    var dataEntries: [ChartDataEntry]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDataPieChart() {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        setChart(months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        dataEntries = []
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let colorRandom = UIColor.getRandomColor()
            colors.append(colorRandom)
        }
        
        pieChartDataSet.colors = colors

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //default state of cell
        dataEntries = nil
        pieChartView = nil
    }
}


