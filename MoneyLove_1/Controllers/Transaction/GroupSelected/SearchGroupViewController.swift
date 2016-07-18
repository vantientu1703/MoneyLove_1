//
//  SearchGroupViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/13/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import CoreData
protocol SearchGroupDelegate: class {
    func doWhenClickBack()
    func doWhenRowSelected(group: Group)
}


class SearchGroupViewController: UIViewController {
    let SEARCH_CELL_HEIGHT = 50
    let TITLE_NAVIGATIONITEM = "SELECT CATEGORY"
    let CELL_IDENTIFIER_DEFAULT = "cellDefaultIdenfier"
    let CACHE_NAME = "MONEY_LOVER_CACHE"

    weak var delegate: SearchGroupDelegate?
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    var searchActive = false
    var filtered = [(name: String, imagePath: String)]()
    var data = [String]()
    var managedObjectContext:NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        managedObjectContext = AppDelegate().managedObjectContext
    }
    
    func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchGroupViewController.clickToBack(_:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = TITLE_NAVIGATIONITEM
    }
    
    func clickToBack(sender: UIBarButtonItem) {
        delegate?.doWhenClickBack()
    }
    
    func filterContent(searchText: String) {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription .entityForName("Group", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
        let predicate = NSPredicate(format: "name contains[cd] %@", argumentArray: [searchText])
        fetchRequest.predicate = predicate
        
        do { let resultsRequest = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Group]
            filtered = resultsRequest.map({(item: Group) -> (String, String) in
                return (item.name!, item.imageName!)
            })

        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
}

extension SearchGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filtered.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER_DEFAULT)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CELL_IDENTIFIER_DEFAULT)
        }
        if searchActive {
            let result = self.filtered[indexPath.row]
            cell!.textLabel?.text = result.name
            cell?.imageView?.image = UIImage(contentsOfFile: result.imagePath)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO
    }
}

extension SearchGroupViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContent(searchText)
        if (filtered.count == 0) {
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.searchTableView.reloadData()
    }
}