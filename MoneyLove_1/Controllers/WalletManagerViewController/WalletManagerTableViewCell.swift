//
//  WalletManagerTableViewCell.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class WalletManagerTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonShowEdit: UIButton!
    @IBOutlet weak var imageViewWallet: UIImageView!
    @IBOutlet weak var labelTotalMoney: UILabel!
    @IBOutlet weak var labelWalletName: UILabel!
    
    func configureCell(data: DataWalletManager, indexPath: NSIndexPath) {
        let wallet = data.getObjectAtIndexPath(indexPath)
        self.labelWalletName.text = wallet.name
        if wallet.firstNumber >= 0 {
            let number = Int(wallet.firstNumber)
            let myString = number.stringFormatedWithSepator
            self.labelTotalMoney.text = "\(myString) đ"
            self.labelTotalMoney.textColor = UIColor.blueColor()
        } else {
            let number = Int(-wallet.firstNumber)
            let myString = number.stringFormatedWithSepator
            self.labelTotalMoney.text = "\(myString) đ"
            self.labelTotalMoney.textColor = UIColor.redColor()
        }
        self.imageViewWallet.image = UIImage(named: wallet.imageName!)

    }
}
