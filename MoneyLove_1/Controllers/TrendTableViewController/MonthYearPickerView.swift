//
//  MonthYearPickerView.swift
//  MoneyLove_1
//
//  Created by framgia on 7/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class MonthYearPickerView: UIPickerView {
    let NUMBER_COMPONENT_PICKER: Int = 2
    let MAX_YEAR: Int = 2050
    let MIN_YEAR: Int = 1980
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var years: [Int]!
    var month: Int = 0 {
        didSet {
            selectRow(month, inComponent: 0, animated: false)
        }
    }
    var year: Int = 0 {
        didSet {
            selectRow(years.indexOf(year)!, inComponent: 1, animated: true)
        }
    }
    var onDateSelected: ((nameMonth: String, indexMonth: Int, year: Int) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        
        var years: [Int] = []
        if years.count == 0 {
            for year in MIN_YEAR...MAX_YEAR {
                years.append(year)
            }
        }
        self.years = years
        self.delegate = self
        self.dataSource = self
        let currentMonth = NSCalendar(identifier: NSCalendarIdentifierGregorian)!.component(.Month, fromDate: NSDate())
        let currentYear = NSCalendar(identifier: NSCalendarIdentifierGregorian)!.component(.Year, fromDate: NSDate())
        self.selectRow(currentMonth-1, inComponent: 0, animated: false)
        self.selectRow((currentYear - MIN_YEAR), inComponent: 1, animated: false)
    }
}

extension MonthYearPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return NUMBER_COMPONENT_PICKER
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRowInComponent(0)
        let nameMonth = months[month]
        let year = years[self.selectedRowInComponent(1)]
        if let block = onDateSelected {
            block(nameMonth: nameMonth, indexMonth: month+1, year: year)
        }
        self.month = month
        self.year = year
    }
}
