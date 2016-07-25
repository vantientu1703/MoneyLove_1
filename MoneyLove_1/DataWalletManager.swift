//
//  DataWalletManager.swift
//  MoneyLove_1
//
//  Created by Quang Huy on 7/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData
class DataWalletManager: NSObject {
    var fetchedResultsController: NSFetchedResultsController!
    let CACHE_NAME = "Wallet_Cache"
    init(frc: NSFetchedResultsController) {
        fetchedResultsController = frc
        super.init()
    }
    
    func getNumberOfObject() -> Int {
        if let sections = self.fetchedResultsController.sections {
            if sections.count > 0 {
                let arrWallets = sections[0]
                return arrWallets.numberOfObjects
            }
        }
        return 0
    }
    
    func getObjectAtIndexPath(indexPath: NSIndexPath) -> Wallet {
        let wallet = fetchedResultsController.objectAtIndexPath(indexPath) as! Wallet
        return wallet
    }
}
