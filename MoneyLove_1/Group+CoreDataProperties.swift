//
//  Group+CoreDataProperties.swift
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

extension Group {

    @NSManaged var idMainGroup: Int32
    @NSManaged var name: String?
    @NSManaged var status: Bool
    @NSManaged var type: Bool
    @NSManaged var imageName: String?
    @NSManaged var transaction: NSSet?
    @NSManaged var wallet: Wallet?

}
