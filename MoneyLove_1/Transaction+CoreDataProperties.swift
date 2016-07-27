//
//  Transaction+CoreDataProperties.swift
//  MoneyLove_1
//
//  Created by Quang Huy on 7/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Transaction {
    @NSManaged var date: NSTimeInterval
    @NSManaged var dayString: String?
    @NSManaged var moneyNumber: Int32
    @NSManaged var monthString: String?
    @NSManaged var note: String?
    @NSManaged var personRelated: String?
    @NSManaged var group: Group?
    @NSManaged var wallet: Wallet?
}
