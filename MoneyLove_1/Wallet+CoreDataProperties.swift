//
//  Wallet+CoreDataProperties.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Wallet {

    @NSManaged var firstNumber: Double
    @NSManaged var imageName: String?
    @NSManaged var name: String?
    @NSManaged var group: NSSet?
    @NSManaged var transaction: NSSet?

}
