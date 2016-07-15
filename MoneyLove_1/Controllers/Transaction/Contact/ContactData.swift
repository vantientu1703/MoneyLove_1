//
//  ContactData.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import UIKit
import Contacts

class ContactData {
    var names = [CNContact]()
    var data = [String]()
    var handleClosure:((vc: ContactViewController)->())?
    func getDataFromUserContact(handleVC: ContactViewController) -> [CNContact]? {
        let status = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        guard status == CNAuthorizationStatus.Denied || status == CNAuthorizationStatus.Restricted else {
            handleClosure!(vc: handleVC)
            return nil
        }
        let store = CNContactStore()
        store.requestAccessForEntityType(CNEntityType.Contacts) { (granted, error) in
            if !granted {
                dispatch_async(dispatch_get_main_queue(), {
                    // user didn't grant access;
                    // so, again, tell user here why app needs permissions in order  to do it's job;
                    // this is dispatched to the main queue because this request could be running on background thread
                })
            } else {
                var contacts = [CNContact]()
                let request: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey, CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName)])
                do { try
                    store.enumerateContactsWithFetchRequest(request, usingBlock: { (contact, error) in
                        contacts.append(contact)
                    })
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                self.names = contacts
                let data = contacts.map({(item: CNContact) -> String in
                    return item.givenName + " " + item.familyName
                })
                self.data = data
                dispatch_async(dispatch_get_main_queue(), {
                    handleVC.myTableView.reloadData();
                })
            }
        }
        return self.names
    }
}
