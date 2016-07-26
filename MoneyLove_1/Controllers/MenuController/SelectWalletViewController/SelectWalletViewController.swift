//
//  SelectWalletViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

enum IndexPathSection: Int {
    case Section_TotalMoney
    case Section_Wallet
    case Section_Bottom
    static let arrSection = [Section_TotalMoney, Section_Wallet, Section_Bottom]
}

class SelectWalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let CACHE_NAME = "MONEY_LOVER_CACHE"
    let HEIGHT_SECTION0: CGFloat = 99.0
    let HEIGHT_SECTION1: CGFloat = 57.0
    let HEIGHT_SECTION2: CGFloat = 47.0
    let IDENTIFIER_TOTALMONEYTABLEVIEWCELL = "TotalMoneyTableViewCell"
    let IDENTIFIER_WALETTTABLEVIEWCELL = "WalletTableViewCell"
    let IDENTIFIER_BOTTOMTABLEVIEWCELL = "BottomTableViewCell"
    let TITLE_ADD_WALLET = "ADD WALLET"
    let TITLE_WALLET_MANAGER = "WALLET MANAGER"
    let IC_ADD_WALLET = "ic_add"
    let IC_MANAGER_WALLET = "ic_manager"
    let arrSections = IndexPathSection.arrSection
    @IBOutlet weak var tableView: UITableView!
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
        self.configRegisterForCell()
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func configRegisterForCell() {
        tableView.registerClass(TotalMoneyTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_TOTALMONEYTABLEVIEWCELL)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_TOTALMONEYTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_TOTALMONEYTABLEVIEWCELL)
        tableView.registerClass(WalletTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_WALETTTABLEVIEWCELL)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_WALETTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_WALETTTABLEVIEWCELL)
        tableView.registerClass(BottomTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_BOTTOMTABLEVIEWCELL)
        tableView.registerNib(UINib.init(nibName: IDENTIFIER_BOTTOMTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_BOTTOMTABLEVIEWCELL)
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case IndexPathSection.Section_TotalMoney.rawValue:
                return 1
            case IndexPathSection.Section_Wallet.rawValue:
                if let sections = self.fetchedResultController.sections {
                    let arrWallets = sections[0]
                    print(arrWallets.objects)
                    return arrWallets.numberOfObjects
                } else {
                    return 0
                }
            case IndexPathSection.Section_Bottom.rawValue:
                return 2
            default:
                return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
            case IndexPathSection.Section_TotalMoney.rawValue:
                let totalMoneyCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_TOTALMONEYTABLEVIEWCELL, forIndexPath: indexPath) as! TotalMoneyTableViewCell
                let numberOfMoney = DataManager.shareInstance.getMoneyOfAllWallets()
                totalMoneyCell.labelTotalMoney.text = "\(numberOfMoney) đ"
                return totalMoneyCell
            case IndexPathSection.Section_Wallet.rawValue:
                let walletCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_WALETTTABLEVIEWCELL, forIndexPath: indexPath) as! WalletTableViewCell
                let indexPath2 = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section - 1)
                let wallet = self.fetchedResultController.objectAtIndexPath(indexPath2) as! Wallet
                walletCell.labelNameWallet.text = wallet.name
                if wallet.firstNumber >= 0 {
                    walletCell.labelTotalMoneyOfWallet.textColor = UIColor.blueColor()
                    walletCell.labelTotalMoneyOfWallet.text = "\(wallet.firstNumber) đ"
                } else {
                    let money = -wallet.firstNumber
                    walletCell.labelTotalMoneyOfWallet.textColor = UIColor.redColor()
                    walletCell.labelTotalMoneyOfWallet.text = "\(money) đ"
                }
                walletCell.imageViewWallet.image = UIImage(named: wallet.imageName!)
                return walletCell
            case IndexPathSection.Section_Bottom.rawValue:
                let bottomCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_BOTTOMTABLEVIEWCELL, forIndexPath: indexPath) as! BottomTableViewCell
                if indexPath.row == 0 {
                    bottomCell.labelAddWallet.text = TITLE_ADD_WALLET
                    bottomCell.imageViewBottom.image = UIImage(named: IC_ADD_WALLET)
                } else {
                    bottomCell.labelAddWallet.text = TITLE_WALLET_MANAGER
                    bottomCell.imageViewBottom.image = UIImage(named: IC_MANAGER_WALLET)
                }
                return bottomCell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
            case IndexPathSection.Section_TotalMoney.rawValue:
               return HEIGHT_SECTION0
            case IndexPathSection.Section_Wallet.rawValue:
                return HEIGHT_SECTION1
            case IndexPathSection.Section_Bottom.rawValue:
                return HEIGHT_SECTION2
            default:
                return CGFloat(-1.0)
        }
    }
    
    //MARK: UITableViewDelagate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == IndexPathSection.Section_Bottom.rawValue {
            if indexPath.row == 0 {
                let addWalletVC = AddWalletViewController()
                addWalletVC.fetchedResultController = self.fetchedResultController
                let nav = UINavigationController(rootViewController: addWalletVC)
                self.presentViewController(nav, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                let walletManagerVC = WalletManagerViewController()
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                walletManagerVC.managedObjectContext = appDelegate.managedObjectContext
                let nav = UINavigationController(rootViewController: walletManagerVC)
                self.presentViewController(nav, animated: true, completion: nil)
            }
        } else if indexPath.section == IndexPathSection.Section_Wallet.rawValue {
            let insteaIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
            let walletItem = self.fetchedResultController.objectAtIndexPath(insteaIndexPath) as! Wallet
            DataManager.shareInstance.currentWallet = walletItem
            DataManager.shareInstance.saveManagedObjectContext()
            NSNotificationCenter.defaultCenter().postNotificationName(POST_CURRENT_WALLET, object: nil)
        }
    }
}

extension SelectWalletViewController: NSFetchedResultsControllerDelegate {
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
            indexPath1 = NSIndexPath(forRow: indexPath.row, inSection: 1)
        }
        if let newIndexPath = newIndexPath {
             indexPathNew = NSIndexPath(forRow: newIndexPath.row, inSection: 1)
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
