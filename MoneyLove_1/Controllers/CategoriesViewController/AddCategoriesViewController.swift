//
//  AddCategoriesViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData

enum Row: Int {
    case CategoryName
    case CategoryType
    case CategoryWallet
    static let allTitles = [CategoryName, CategoryType, CategoryWallet]
    
    func imageName() -> String {
        switch self {
        case .CategoryName:
            return "question"
        case .CategoryType:
            return "ic_type"
        case .CategoryWallet:
            return "wallet"
        }
    }
    func title() -> String {
        switch self {
        case .CategoryName:
            return "Category Name"
        case .CategoryType:
            return "Type"
        case .CategoryWallet:
            return "Wallet Name"
        }
    }
    
    func fontSize() -> CGFloat {
        let fontSize14: CGFloat = 14.0
        let fontSize17: CGFloat = 17.0
        switch self {
        case .CategoryName:
            return fontSize17
        case .CategoryType:
            return fontSize14
        case .CategoryWallet:
            return fontSize17
        }
    }
}

protocol AddCategoriesViewControllerDelegate: class {
    func delegateDoWhenDelete(groupDeleted: Group)
}

class AddCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNote: UILabel!
    var statusEdit = ""
    var newIndexPath: NSIndexPath!
    let HEIGHT_CELL_ADDCATEGORIES: CGFloat = 50.0
    let IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL = "AddCategoriesTableViewCell"
    let NEW_CATEGORY = "New Category"
    let arrTitles = Row.allTitles
    var wallet: Wallet!
    var imageNameWallet: String = ""
    var imageNameCategory: String = ""
    var indexPath: NSIndexPath!
    var typeBool = true
    let FILL_CATEGORY_NAME = "Fill category name,please"
    let SELECT_IMAGE_CATEGORY = "Select image category,please"
    let SELECT_WALLET = "Select wallet,please"
    var fetchedResultController: NSFetchedResultsController!
    weak var delegate: AddCategoriesViewControllerDelegate?
    let CACHE_NAME = "Group_Cache"
    let CELL_DEFAULT = "CellDefault"
    let EXPENSE = "Expense"
    let INCOME = "Income"
    var categoryItem: Group!
    var arrTiltes: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configForCell()
        self.title = NEW_CATEGORY
        if statusEdit == EDIT {
            let rightButton = UIBarButtonItem(title: DONE_TITLE, style: UIBarButtonItemStyle.Plain,
                target: self, action: #selector(AddCategoriesViewController.doneAddCategotiesPress(_:)))
            self.navigationItem.rightBarButtonItem = rightButton
        } else {
            let rightButton = UIBarButtonItem(image: UIImage(named: IMAGE_BUTTON_ADD), style: UIBarButtonItemStyle.Plain,
                target: self, action: #selector(AddCategoriesViewController.doneAddCategotiesPress(_:)))
            self.navigationItem.rightBarButtonItem = rightButton
            if let font = UIFont(name: "Arial", size: FONT_SIZE) {
                rightButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            }
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddCategoriesViewController.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.automaticallyAdjustsScrollViewInsets = false
        tapGesture.delegate = self
        if statusEdit == EDIT {
            typeBool = self.categoryItem.type
            self.imageNameWallet = (self.categoryItem.wallet?.imageName)!
            self.imageNameCategory = self.categoryItem.imageName!
        }
    }
    
    func tapped(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func doneAddCategotiesPress(sender: AnyObject) {
        var pass: Bool = true
        if statusEdit == EDIT {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddCategoriesTableViewCell
            if let name = cell.txtCategoryName.text {
                if name.isEmpty {
                    self.labelNote.text = FILL_CATEGORY_NAME
                    pass = false
                }
            } else {
                pass = false
            }
            if imageNameCategory.isEmpty {
                self.labelNote.text = SELECT_IMAGE_CATEGORY
                pass = false
            }
            if imageNameWallet.isEmpty {
                self.labelNote.text = SELECT_WALLET
                pass = false
            }
            if pass {
                self.categoryItem.name = cell.txtCategoryName.text!
                self.categoryItem.imageName = imageNameCategory
                self.categoryItem.wallet = DataManager.shareInstance.currentWallet
                self.categoryItem.type = typeBool
                self.categoryItem.subType = typeBool ? 1 : 0
                DataManager.shareInstance.saveManagedObjectContext()
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddCategoriesTableViewCell
            if (cell.txtCategoryName.text?.isEmpty)! {
                self.labelNote.text = FILL_CATEGORY_NAME
                pass = false
            }
            if imageNameCategory.isEmpty {
                self.labelNote.text = SELECT_IMAGE_CATEGORY
                pass = false
            }
            if imageNameWallet.isEmpty {
                self.labelNote.text = SELECT_WALLET
                pass = false
            }
            if pass {
                if let arrCategories = DataManager.shareInstance.getAllGroups() {
                    for group in  arrCategories {
                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddCategoriesTableViewCell
                        if group.name == cell.txtCategoryName.text {
                            self.labelNote.text = CATEGORY_IS_EXISTED
                            return
                        }
                    }
                }
                let newCategory = DataManager.shareInstance.addNewGroup(self.fetchedResultController)
                newCategory?.name = cell.txtCategoryName.text!
                newCategory?.imageName = imageNameCategory
                newCategory?.wallet = DataManager.shareInstance.currentWallet
                newCategory?.type = typeBool
                newCategory?.subType = typeBool ? 1 : 0
                DataManager.shareInstance.saveManagedObjectContext()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func configForCell() {
        tableView.registerNib(UINib(nibName: IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL)
    }
    
    //MARK: UITableViewDataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowIndex = arrTitles[indexPath.row];
        if indexPath.row == 0 {
            let addCategoriesCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL, forIndexPath: indexPath) as! AddCategoriesTableViewCell
            addCategoriesCell.delegate = self
            addCategoriesCell.indexPath = indexPath
            if statusEdit == EDIT {
                addCategoriesCell.txtCategoryName.text = self.categoryItem.name
                addCategoriesCell.buttonImageCategory.setBackgroundImage(UIImage(named: self.categoryItem.imageName!), forState: UIControlState.Normal)
            } else {
                addCategoriesCell.txtCategoryName.placeholder = rowIndex.title()
                addCategoriesCell.buttonImageCategory.setBackgroundImage(UIImage(named: rowIndex.imageName()), forState: UIControlState.Normal)
            }
            addCategoriesCell.txtCategoryName.font = UIFont.systemFontOfSize(rowIndex.fontSize())
            addCategoriesCell.txtCategoryName.delegate = self
            return addCategoriesCell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier(CELL_DEFAULT)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: CELL_DEFAULT)
            }
            if statusEdit == EDIT {
                if indexPath.row == 1 {
                    if self.categoryItem.type {
                        cell!.textLabel!.text = EXPENSE
                    } else {
                        cell!.textLabel!.text = INCOME
                    }
                    cell!.imageView!.image = UIImage(named: rowIndex.imageName())
                } else {
                    cell!.imageView!.image = UIImage(named: (self.categoryItem.wallet?.imageName)!)
                    cell!.textLabel!.text = self.categoryItem.wallet?.name
                }
            } else {
                cell?.imageView?.image = UIImage(named: rowIndex.imageName())
                cell?.textLabel?.text = rowIndex.title()
            }
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL_ADDCATEGORIES
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        typeBool = !typeBool
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.view.endEditing(true)
        switch indexPath.row {
        case Row.CategoryType.rawValue:
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if typeBool {
                cell?.textLabel?.text = EXPENSE
            } else {
                cell?.textLabel?.text = INCOME
            }
            break
        case Row.CategoryWallet.rawValue:
            self.indexPath = indexPath
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let walletManagerVC = WalletManagerViewController()
            walletManagerVC.statusPush = PUSH_TITLE
            walletManagerVC.delegate = self
            walletManagerVC.managedObjectContext = appDelegate.managedObjectContext
            self.navigationController?.pushViewController(walletManagerVC, animated: true)
            break
        default:
            break
        }
    }
}

extension AddCategoriesViewController: WalletManagerViewControllerDelegate {
    func didSelectWallet(wallet: Wallet) {
        self.wallet = wallet
        self.imageNameWallet = wallet.imageName! == "" ? DEFAULT : wallet.imageName!
        let cell = tableView.cellForRowAtIndexPath(self.indexPath)
        cell?.imageView?.image = UIImage(named: imageNameWallet)
        cell?.textLabel?.text = wallet.name
    }
}
extension AddCategoriesViewController: AddCategoriesTableViewCellDelegate {
    func pressButtonSelectImage(indexPath: NSIndexPath) {
        newIndexPath = indexPath
        let iconManagerVC = IconManagerViewController()
        iconManagerVC.delegate = self
        self.navigationController?.pushViewController(iconManagerVC, animated: true)
    }
}

extension AddCategoriesViewController: IconManagerViewControllerDelegate {
    func didSelectIconName(imageName: String) {
        let cell = tableView.cellForRowAtIndexPath(newIndexPath) as! AddCategoriesTableViewCell
        cell.buttonImageCategory.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        self.imageNameCategory = imageName
        print(imageName)
    }
}

extension AddCategoriesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddCategoriesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let viewTouched = touch.view {
            if viewTouched.isDescendantOfView(tableView) {
                return false
            }
        }
        return true
    }
}