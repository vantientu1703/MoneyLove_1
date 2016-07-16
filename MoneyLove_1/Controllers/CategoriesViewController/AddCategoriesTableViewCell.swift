//
//  AddCategoriesTableViewCell.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

protocol AddCategoriesTableViewCellDelegate: class {
    func pressButtonSelectImage(indexPath: NSIndexPath)
}
class AddCategoriesTableViewCell: UITableViewCell {
    var indexPath: NSIndexPath!
    weak var delegate: AddCategoriesTableViewCellDelegate!
    @IBOutlet weak var buttonImageCategory: UIButton!
    @IBOutlet weak var txtCategoryName: UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonCategoryImagePress(sender: AnyObject) {
        self.delegate.pressButtonSelectImage(self.indexPath)
    }
}
