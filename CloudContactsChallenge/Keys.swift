//
//  Keys.swift
//  CloudContactsChallenge
//
//  Created by Clay Mills on 4/21/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Foundation

struct Keys {
    
    static let contactCellReuseIdentifier = "contactCell"
    static let contactDetailSeque = "toContactDetail"
    static let addContactSeque = "addNewContact"
    
    static let contactRecordType = "Contact"
    static let nameKey = "name"
    static let phoneNumberKey = "number"
    static let emailKey = "email"
    
    static let DidRefreshNotification = Notification.Name("DidRefreshNotification")
}
