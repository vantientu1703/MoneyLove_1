//
//  Extension_UIColor.swift
//  MoneyLove_1
//
//  Created by framgia on 7/13/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation

extension UIColor {
    class func getRandomColor() ->UIColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        return color
    }
}