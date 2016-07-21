//
//  AddCategoriesViewController.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit


enum Row: Int {
    case CategoryName
    case CategoryType
    case CategoryParent
    case CategoryWallet
    static let allTitles = [CategoryName,CategoryType,CategoryParent,CategoryWallet]
    
    func imageName() -> String {
        switch self {
        case .CategoryName:
            return "ic_question"
        case .CategoryType:
            return "ic_type"
        case .CategoryParent:
            return "ic_parent"
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
        case .CategoryParent:
            return "Parent"
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
        case .CategoryParent:
            return fontSize14
        case .CategoryWallet:
            return fontSize17
        }
    }
}
class AddCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var newIndexPath: NSIndexPath!
    let HEIGHT_CELL_ADDCATEGORIES: CGFloat = 50.0
    let IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL = "AddCategoriesTableViewCell"
    let TITLE_BUTTON_DONE = "Done"
    let NEW_CATEGORY = "New Category"
    let arrTitles = Row.allTitles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configForCell()
        self.title = NEW_CATEGORY
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: TITLE_BUTTON_DONE, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddCategoriesViewController.doneAddCategotiesPress(_:)))
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(AddCategoriesViewController.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func tapped(sender: AnyObject) {
        print("tapped")
    }
    func doneAddCategotiesPress(sender: AnyObject) {
        //TODO 
    }
    
    func configForCell() {
        tableView.registerClass(AddCategoriesTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL)
        tableView.registerNib(UINib(nibName: IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL)
    }
    
    //MARK: UITableViewDataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let addCategoriesCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_ADDCATEGORIES_TABLEVIEWCELL, forIndexPath: indexPath) as! AddCategoriesTableViewCell
        let rowIndex = arrTitles[indexPath.row];
        addCategoriesCell.delegate = self
        addCategoriesCell.indexPath = indexPath
        addCategoriesCell.txtCategoryName.placeholder = rowIndex.title()
        addCategoriesCell.txtCategoryName.font = UIFont.systemFontOfSize(rowIndex.fontSize())
        addCategoriesCell.txtCategoryName.delegate = self
        addCategoriesCell.buttonImageCategory.setBackgroundImage(UIImage(named: rowIndex.imageName()), forState: UIControlState.Normal)
        if indexPath.row != 0 {
            addCategoriesCell.buttonImageCategory.enabled = false
            addCategoriesCell.txtCategoryName.enabled = false
        }
        return addCategoriesCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL_ADDCATEGORIES
    }
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
        print(imageName)
    }
}

extension AddCategoriesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}