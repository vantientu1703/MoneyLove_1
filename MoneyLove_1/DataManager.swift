//
//  DataManager.swift
//  MoneyLove_1
//
//  Created by macmini-0017 on 7/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

import Foundation

class DataManager {
    class var shareInstance: DataManager {
        struct Singleton{
            static let instance = DataManager()
        }
        return Singleton.instance
    }
    //MARK: Wallet
    func addNewWallet(newWallet: Wallet) {
        //TODO
    }
    
    func removeWallet(walletRemoved: Wallet) {
        //TODO

    }
    
    func replaceWallet(oldWallet: Wallet, newWallet: Wallet) {
        //TODO

    }
    
    
    //Mark: Group
    func addNewGroup(newGroup: Group) {
        //TODO

    }
    
    func removeGroup(groupRemoved: Group){
        //TODO

    }
    
    func replaceGroup(oldGroup: Group, newGroup: Group) {
        //TODO

    }
    //MARK: Transaction
    func addNewTransaction(newTrans: Transaction) {
        //TODO

    }
    
    func removeTrans(transRemoved: Transaction) {
        //TODO

    }
    
    func replaceTrans(old: Transaction, new: Transaction) {
        //TODO

    }
    
        
    
}