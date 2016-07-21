//
//  ManagerIcon.swift
//  MoneyLove_1
//
//  Created by Quang Huy on 7/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class ManagerIcon: NSObject {
    class func getArrayImages() -> NSArray{
        let filePath = NSBundle.mainBundle().pathForResource("Icon", ofType: "plist")
        let raw = NSArray(contentsOfFile: filePath!)
        var arrIcons :[AnyObject] = []
        for item in raw! {
            let i = item as! [String:String]
            let iconItem = IconItem()
            iconItem.name = i["name"]
            arrIcons.append(iconItem)
        }
        return arrIcons
    }
}
