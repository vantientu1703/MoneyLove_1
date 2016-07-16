//
//  Transaction+CoreDataProperties.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Transaction {

    @NSManaged var date: NSTimeInterval
    @NSManaged var moneyNumber: Double
    @NSManaged var note: String?
    @NSManaged var personRelated: String?
    @NSManaged var group: Group?
    @NSManaged var wallet: Wallet?

}
