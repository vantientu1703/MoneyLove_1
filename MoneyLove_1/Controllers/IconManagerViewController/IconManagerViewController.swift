//
//  IconManagerViewController.swift
//  MoneyLove_1
//
//  Created by Quang Huy on 7/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

protocol IconManagerViewControllerDelegate: class {
    func didSelectIconName(imageName: String)
}
class IconManagerViewController: UIViewController {
    
    let SEELECT_ICON = "Select Icon"
    @IBOutlet weak var collectionView: UICollectionView!
    let IDENTIFIER_COLLECTIONVIEW_CELL = "IconManagerCollectionViewCell"
    var arrIcons: NSArray!
    weak var delegate: IconManagerViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        collectionView.backgroundColor = UIColor.whiteColor()
        self.title = SEELECT_ICON
        self.configCollectionCell()
        arrIcons = ManagerIcon.getArrayImages()
    }
    
    func configCollectionCell() {
        collectionView.registerNib(UINib(nibName: IDENTIFIER_COLLECTIONVIEW_CELL, bundle: nil), forCellWithReuseIdentifier: IDENTIFIER_COLLECTIONVIEW_CELL)
    }
}

extension IconManagerViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrIcons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(IDENTIFIER_COLLECTIONVIEW_CELL, forIndexPath: indexPath) as! IconManagerCollectionViewCell
        let icon = arrIcons[indexPath.row] as! IconItem
        collectionCell.imageViewIcon.image = UIImage(named: icon.name)
        collectionCell.contentView.backgroundColor = UIColor.greenColor()
        return collectionCell
    }
}

extension IconManagerViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let icon = arrIcons[indexPath.row]
        self.delegate.didSelectIconName(icon.name)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
