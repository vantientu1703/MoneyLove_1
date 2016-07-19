//
//  CategoriesTableViewCell.swift
//  MoneyLove_1
//
//  Created by Văn Tiến Tú on 7/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var imageViewCategories: UIImageView!
    @IBOutlet weak var labelMainCategories: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let IDENTIFIER_DETAIL_TABLEVIEWCELL = "DetailTableViewCell"
    let HEIGHT_CELL_DETAIL: CGFloat = 50.0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configTableViewCell()
    }
    
    func configTableViewCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(DetailTableViewCell.classForCoder(), forCellReuseIdentifier: IDENTIFIER_DETAIL_TABLEVIEWCELL)
        tableView.registerNib(UINib(nibName: IDENTIFIER_DETAIL_TABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: IDENTIFIER_DETAIL_TABLEVIEWCELL)
    }
    
    //MARK: UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let detailCell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_DETAIL_TABLEVIEWCELL, forIndexPath: indexPath)
        // TODO
        return detailCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HEIGHT_CELL_DETAIL
    }
}
