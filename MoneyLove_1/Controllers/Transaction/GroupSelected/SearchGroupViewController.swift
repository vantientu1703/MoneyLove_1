//
//  SearchGroupViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/13/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
protocol SearchGroupDelegate: class {
    func doWhenClickBack()
    func doWhenRowSelected(group: Group)
}


class SearchGroupViewController: UIViewController {
    let SEARCH_CELL_HEIGHT = 50
    let TITLE_NAVIGATIONITEM = "SELECT CATEGORY"
    let CELL_IDENTIFIER_DEFAULT = "cellDefaultIdenfier"
    
    weak var delegate: SearchGroupDelegate?
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchGroupViewController.clickToBack(_:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = TITLE_NAVIGATIONITEM
    }
    
    func clickToBack(sender: UIBarButtonItem) {
        delegate?.doWhenClickBack()
    }
}

extension SearchGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER_DEFAULT)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CELL_IDENTIFIER_DEFAULT)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SEARCH_CELL_HEIGHT
    }
}
