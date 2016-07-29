//
//  ChartTableViewCell.swift
//  MoneyLove_1
//
//  Created by framgia on 7/7/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import Charts

class BarChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var barChartView: BarChartView!
    var months: [String]!
    var unitsSoldDic: [Double]!
    var dataEntries: [BarChartDataEntry]!
    let CHART_MESSAGE = "You need to provide data for the chart."
    let DATE_FORMAT = "MM/yyyy"
    let COLOR_CHART = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: CHART EXPENSEN INCOME
    func setDataDictionaryExpenseIncome(dataDic: [Dictionary<String, AnyObject>], fromDate: NSDate, toDate: NSDate, currentCategoryType: CategoryType) {
        months = [String]()
        unitsSoldDic = [Double]()
        for dic in dataDic {
            let nameMonth = dic["monthString"] as! String
            if currentCategoryType == CategoryType.Expense {
                let expenseValue = dic["expense"] as! Double
                months.append(nameMonth)
                unitsSoldDic.append(expenseValue)
            }
            
            if currentCategoryType == CategoryType.Income {
                let incomeValue = dic["income"] as! Double
                months.append(nameMonth)
                unitsSoldDic.append(incomeValue)
            }
        }
        setChart(months, values: unitsSoldDic, fromDate: fromDate, toDate: toDate)
    }
    
    func setChart(dataPoints: [String], values: [Double], fromDate: NSDate, toDate: NSDate) {
        barChartView.noDataText = CHART_MESSAGE
        dataEntries = []
        for (index, value) in values.enumerate() {
            let dataEntry = BarChartDataEntry(value: value, xIndex: index)
            dataEntries.append(dataEntry)
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "\(dateFormatter.stringFromDate(fromDate)) - \(dateFormatter.stringFromDate(toDate))")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.descriptionText = ""
        chartDataSet.colors = [COLOR_CHART]
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
    }
    
    //MARK: CHART NETINCOME
    func setDataDictionaryNetIcome(dataList: [Dictionary<String, AnyObject>]) {
        var values = [BarChartDataEntry]()
        var dates = [String]()
        var colors = [UIColor]()
        let green = UIColor.greenColor()
        let red = UIColor.redColor()
        for i in 0 ..< dataList.count {
            let dicItem = dataList[i]
            let xIndex = i
            let expenseValue = dicItem["expense"] as! Double * (-1)
            let incomeValue = (dicItem["income"] as! Double)
            let date = ""
            var entry: BarChartDataEntry = BarChartDataEntry(values: [expenseValue], xIndex: xIndex)
            values.append(entry)
            dates.append(date)
            colors.append(red)
            entry = BarChartDataEntry(values: [incomeValue], xIndex: xIndex)
            values.append(entry)
            dates.append(date)
            colors.append(green)
        }
        let set = BarChartDataSet(yVals: values, label: "")
        set.barSpace = 0.4
        set.colors = colors;
        set.valueColors = colors
        let data = BarChartData(xVals: dates, dataSet: set)
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        data.setValueFormatter(formatter)
        barChartView.data = data
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.labelFont = UIFont.systemFontOfSize(13.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.months = nil
        self.dataEntries = nil
    }
}

extension BarChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(months[entry.xIndex])")
    }
}

