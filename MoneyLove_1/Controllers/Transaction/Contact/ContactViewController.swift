//
//  ContactViewController.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import Contacts

protocol TransactionVCDelegate {
    func displayContact(newName:String?)
}

class ContactViewController: UIViewController {
    let TITLE_NAVIGATIONITEM = "WITH"
    let TITLE_ACTION_CONTROLLER = "OK"
    let MESSAGE_ALERT_CONTROLLER = "This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts"
    let CELL_IDENTIFIER = "CELLIDENTIFIER"
    var contactData: ContactData?
    weak var delegate: TransactionViewController?
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var contactSearchBar: UISearchBar!
    var filtered = [String]()
    var data = [String]()
    var results = [String]() {
        didSet {
            textBefore = results.joinWithSeparator(",") + ","
        }
    }
    var searchActive = false
    var isCleared = false
    lazy var textBefore: String! = {[weak self] in
        let str = self!.results.joinWithSeparator(",") + ","
        return str
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        contactData = ContactData()
        let handleClosure = {[weak self](vc: ContactViewController) -> () in
            let alertController = UIAlertController(title: nil, message: self!.MESSAGE_ALERT_CONTROLLER , preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: self!.TITLE_ACTION_CONTROLLER, style: UIAlertActionStyle.Default, handler: nil)
            alertController .addAction(action)
            self!.presentViewController(alertController, animated: true, completion: nil)
        }
        contactData?.handleClosure = handleClosure
        contactData?.getDataFromUserContact(self)
        contactSearchBar.delegate = self
        contactSearchBar.returnKeyType = UIReturnKeyType.Done
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configureNavigationBar()
        myTableView.reloadData()
    }
    
    func configureNavigationBar() {
        let leftButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ContactViewController.clickToBack(_:)))
        let rightButton = UIBarButtonItem(title:"Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContactViewController.clickToSave(_:)))
        self.navigationItem.title = TITLE_NAVIGATIONITEM
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func clickToBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickToSave(sender: UIBarButtonItem) {
        if delegate!.respondsToSelector(Selector("displayContact:")) {
            self.delegate?.displayContact(contactSearchBar.text)
        }
        self.delegate?.navigationController?.popViewControllerAnimated(true)
    }
}

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filtered.count : self.contactData!.names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CELL_IDENTIFIER)
        }
        if searchActive {
            let name = self.filtered[indexPath.row]
            cell!.textLabel?.text = name
        } else {
            let name = self.contactData?.data[indexPath.row]
            cell!.textLabel?.text = name
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var arrayTemp = contactSearchBar.text?.componentsSeparatedByString(",")
        arrayTemp?.removeLast()
        var contact: CNContact
        var fullName: String
        if searchActive {
            fullName = filtered[indexPath.row]
        } else {
            contact = self.contactData!.names[indexPath.row]
            fullName = contact.givenName + " " + contact.familyName
        }
        
        let check = self.checkExisted(fullName)
        if !check {
            if let text = contactSearchBar.text {
                if text.isEmpty {
                    contactSearchBar.text = fullName
                } else {
                    contactSearchBar.text = contactSearchBar.text! + "," + fullName
                }
                results.append(fullName)
                contactSearchBar.text = results.joinWithSeparator(",") + ","
            }
        }
        textBefore = contactSearchBar.text
    }
    
    func checkExisted(name: String) -> Bool {
        for item in results {
            if item == name {
                return true
            }
        }
        return false
    }
}

extension ContactViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        isCleared = !searchActive
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        if let text = searchBar.text {
            results = text.componentsSeparatedByString(",")
            let lastChar = text[text.endIndex.predecessor()]
            if lastChar != "," {
                searchBar.text = searchBar.text! + ","
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > textBefore.characters.count {
            if searchText.characters.last == "," {
                results = textBefore.componentsSeparatedByString(",")
            } else {
                let arrayTemp = searchText.componentsSeparatedByString(",")
                let lastStr = arrayTemp.last
                filtered = contactData!.data.filter({(text) -> Bool in
                    let tmp: NSString = text
                    let range = tmp.rangeOfString(lastStr!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                    return range.location != NSNotFound
                })
                searchActive = filtered.count > 0
                self.myTableView.reloadData()
            }
        } else {
            if searchText == "" {
                searchActive = false
                isCleared = true
                results.removeAll()
                self.myTableView.reloadData()
            } else {
                if textBefore.characters.last != "," {
                    var arrayTemp = textBefore.componentsSeparatedByString(",")
                    arrayTemp.removeLast()
                    searchBar.text = results.joinWithSeparator(",") + ","
                } else {
                    results.removeLast()
                    if results.count > 0 {
                        searchBar.text = results.joinWithSeparator(",") + ","
                    } else {
                        searchBar.text = ""
                        searchActive = false
                        isCleared = true
                        self.myTableView.reloadData()
                    }
                }
            }
        }
        textBefore = searchBar.text
    }
}
