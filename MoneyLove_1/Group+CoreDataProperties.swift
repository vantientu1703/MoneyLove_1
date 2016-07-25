//
//  Group+CoreDataProperties.swift
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

extension Group {

    @NSManaged var imageName: String?
    @NSManaged var name: String?
    @NSManaged var subType: Int16
    @NSManaged var type: Bool
    @NSManaged var transaction: NSSet?
    @NSManaged var wallet: Wallet?

}
