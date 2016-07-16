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
    let HEIHT_CELL_WALLETMANAGER: CGFloat = 60.0
    weak var delegate: WalletManagerViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonWallet: UIButton!
    var managedObjectContext: NSManagedObjectContext!
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
        self.title = TITLE_WALLET_MANAGER
        if statusPush != PUSH {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: TITLE_BUTTON_LEFT, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WalletManagerViewController.cancelButton(_:)));
        }
        self.configRegisterForCell()
        addButtonWallet.layer.cornerRadius = 20.0
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
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
    
    func configRegisterForCell() {
        tableView.registerClass(WalletManagerTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_WALLET_MANAGER)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_WALLET_MANAGER, bundle: nil), forCellReuseIdentifier: IDENTIFIER_WALLET_MANAGER)
    }
        
    func cancelButton(sender: AnyObject) {
        if statusPush == PUSH {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: UITableViewDataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultController.sections {
            let arrWallets = sections[0]
            print(arrWallets.objects)
            return arrWallets.numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let walletManagerCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_WALLET_MANAGER, forIndexPath: indexPath) as! WalletManagerTableViewCell
        let wallet = self.fetchedResultController.objectAtIndexPath(indexPath) as! Wallet
        walletManagerCell.labelWalletName.text = wallet.name
        walletManagerCell.labelTotalMoney.text = "\(wallet.firstNumber)"
        walletManagerCell.imageViewWallet.image = UIImage(named: wallet.imageName!)
        return walletManagerCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIHT_CELL_WALLETMANAGER
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if statusPush == PUSH {
            let wallet = self.fetchedResultController.objectAtIndexPath(indexPath) as! Wallet
            self.delegate?.didSelectWallet(wallet)
            self.navigationController?.popViewControllerAnimated(true)
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

