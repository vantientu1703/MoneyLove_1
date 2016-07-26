//
//  WalletManagerViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

protocol WalletManagerViewControllerDelegate: class {
    func didSelectWallet(wallet: Wallet)
}

class WalletManagerViewController: UIViewController, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {
    var statusPush: String?
    let CACHE_NAME = "MONEY_LOVER_CACHE"
    let IDENTIFIER_WALLET_MANAGER = "WalletManagerTableViewCell"
    let TITLE_WALLET_MANAGER = "Wallet Manager"
    let TITLE_BUTTON_LEFT = "Left"
    let ACTION_DELETE = "Delete"
    let ACTION_EDIT = "Edit"
    let HEIHT_CELL_WALLETMANAGER: CGFloat = 60.0
    weak var delegate: WalletManagerViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonWallet: UIButton!
    var managedObjectContext: NSManagedObjectContext!
    var data: DataWalletManager!
    lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchedRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(Wallet.CLASS_NAME, inManagedObjectContext: self.managedObjectContext)
        fetchedRequest.entity = entity
        fetchedRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let arraySortDescriptor = [sortDescriptor]
        fetchedRequest.sortDescriptors = arraySortDescriptor
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: self.CACHE_NAME)
        aFetchedResultsController.delegate = self
        return aFetchedResultsController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonWallet.layer.cornerRadius = 20.0
        self.automaticallyAdjustsScrollViewInsets = false
        self.configureNavigationBar()
        self.performRequest()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func  addWalletPress(sender: AnyObject) {
        let addWallet = AddWalletViewController()
        addWallet.fetchedResultController = self.fetchedResultController
        let nav = UINavigationController(rootViewController: addWallet)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func performRequest() {
        data = DataWalletManager(frc: fetchedResultController)
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func configureNavigationBar() {
        self.title = TITLE_WALLET_MANAGER
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: MENU_TITLE, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WalletManagerViewController.cancelButton(_:)));
        self.configRegisterForCell()
    }
    
    func configRegisterForCell() {
        tableView.registerClass(WalletManagerTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_WALLET_MANAGER)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_WALLET_MANAGER, bundle: nil), forCellReuseIdentifier: IDENTIFIER_WALLET_MANAGER)
    }
    
    func cancelButton(sender: AnyObject) {
        if statusPush == "push"{
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: UITableViewDataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.getNumberOfObject()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let walletManagerCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_WALLET_MANAGER, forIndexPath: indexPath) as! WalletManagerTableViewCell
        walletManagerCell.configureCell(data, indexPath: indexPath)
        return walletManagerCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIHT_CELL_WALLETMANAGER
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: ACTION_DELETE) { (action, index) in
            let alertControlelr = UIAlertController(title: "Reminder", message: "Are you make sure delete wallet?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let actionOk = UIAlertAction(title: OK_TITLE, style: .Destructive, handler: { [weak self](UIAlertAction) in
                let walletItem = self?.fetchedResultController.objectAtIndexPath(indexPath)
                DataManager.shareInstance.removeWallet(walletItem as! Wallet, fetchedResultsController: self!.fetchedResultController)
                NSNotificationCenter.defaultCenter().postNotificationName(MESSAGE_ADD_NEW_TRANSACTION, object: nil)
                })
            let actionCancel = UIAlertAction(title: CANCEL_TITLE, style: .Default, handler: { (UIAlertAction) in
            })
            alertControlelr.addAction(actionOk)
            alertControlelr.addAction(actionCancel)
            self.presentViewController(alertControlelr, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        
        let editAction = UITableViewRowAction(style: .Normal, title: ACTION_EDIT) { [weak self](action, index) in
            let addWalletVC = AddWalletViewController()
            addWalletVC.statusEdit = EDIT
            let walletItem = self?.fetchedResultController.objectAtIndexPath(indexPath) as! Wallet
            addWalletVC.walletItem = walletItem
            self!.presentViewController(UINavigationController.init(rootViewController: addWalletVC), animated: true, completion: nil)
        }
        editAction.backgroundColor = UIColor.greenColor()
        return [deleteAction, editAction]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if statusPush == "push" {
            if let wallet = self.fetchedResultController.objectAtIndexPath(indexPath) as? Wallet {
                self.delegate?.didSelectWallet(wallet)
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else {
            if let walletItem = self.fetchedResultController.objectAtIndexPath(indexPath) as? Wallet {
                DataManager.shareInstance.currentWallet = walletItem
            }
        }
    }
}

extension WalletManagerViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        var indexPathNew: NSIndexPath?
        var indexPath1: NSIndexPath?
        if let indexPath = indexPath {
            indexPath1 = indexPath
        }
        if let newIndexPath = newIndexPath {
            indexPathNew = newIndexPath
        }
        switch (type) {
        case .Insert:
            tableView.insertRowsAtIndexPaths([indexPathNew!], withRowAnimation: .Fade)
            break;
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath1!], withRowAnimation: .Fade)
            break;
        case .Update:
            tableView.rectForRowAtIndexPath(indexPath1!)
            break;
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath1!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([indexPathNew!], withRowAnimation: .Fade)
            break;
        }
    }
}
