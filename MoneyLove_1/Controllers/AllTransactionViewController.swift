//
//  AllTransactionViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/13/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData
class AllTransactionViewController: UIViewController {
    var managedObjectContext:NSManagedObjectContext!
    
    lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchedRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Transaction", inManagedObjectContext: self.managedObjectContext)
        fetchedRequest.entity = entity
        fetchedRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: Transaction.DATE_VARIABLE_NAME, ascending: false)
        let arraySortDescriptor = [sortDescriptor]
        fetchedRequest.sortDescriptors = arraySortDescriptor
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Temp")
        aFetchedResultsController.delegate = self
        return aFetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickToAddTrans(sender: AnyObject) {
        let context = self.fetchedResultController.managedObjectContext
        let entity = self.fetchedResultController.fetchRequest.entity
        let newTrans = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: context) as! Transaction
        //Save the context
        do {
            try context.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        let transVC =  TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        transVC.managedObjectContext = context
        transVC.managedTransactionObject = newTrans
        transVC.delegate = self
        navigationController?.pushViewController(transVC, animated: true)
    }
}

extension AllTransactionViewController: NSFetchedResultsControllerDelegate {
    //TODO
}

extension AllTransactionViewController: TransactionViewControllerDelegate {
    func delegateDoWhenCancel(trans: Transaction?) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    func delegateDoWhenSave(trans: Transaction?) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
