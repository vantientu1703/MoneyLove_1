//
//  Extension_Integer.swift
//  MoneyLove_1
//
 //  Created by macmini-0017 on 7/28/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation
struct Number {
    static let formatterWithSepator: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
}

extension IntegerType {
    var stringFormatedWithSepator: String {
        return Number.formatterWithSepator.stringFromNumber(hashValue) ?? ""
    }
}
