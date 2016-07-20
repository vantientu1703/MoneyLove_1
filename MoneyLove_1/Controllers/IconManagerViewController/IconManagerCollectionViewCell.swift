//
//  IconManagerCollectionViewCell.swift
//  MoneyLove_1
//
//  Created by Quang Huy on 7/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class IconManagerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
    }

}
