//
//  ContactController.swift
//  CloudContactsChallenge
//
//  Created by Clay Mills on 4/21/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Foundation

class ContactController {
    
    static let shared = ContactController()
    private let cloudKitManager = CloudKitManager()
    
    var contacts = [Contact]() {
        didSet {
            DispatchQueue.main.async {
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: Keys.DidRefreshNotification, object: self)
            }
        }
    }
    
    init() {
        refreshData()
    }
    
    func create(contact: Contact, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let record = contact.cloudKitRecord
        cloudKitManager.save(record) { (error) in
            defer { completion(error) }
            if let error = error {
                NSLog(error.localizedDescription)
            }
            self.contacts.append(contact)
        }
    }
    
    func refreshData(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let sortDescriptors = [NSSortDescriptor(key: Keys.nameKey, ascending: false)]
        cloudKitManager.fetchRecords(ofType: Keys.nameKey) { (records, error) in
            defer { completion(error) }
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            guard let records = records else { return }
            self.contacts = records.flatMap { Contact(cloudKitRecord: $0) }
        }
    }
    func subscribeToPushNotifications(completion: @escaping ((Error?) -> Void) = { _ in }) {
        cloudKitManager.subscribeToCreationOfRecords(withType: Keys.contactRecordType) { (error) in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            completion(error)
        }
    }
}
