//
//  CloudKitManager.swift
//  CloudContactsChallenge
//
//  Created by Clay Mills on 4/21/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CloudKitManager {
    let publicDataBase = CKContainer.default().publicCloudDatabase
    
    func fetchRecords(ofType type: String, withSortDescriptors sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        query.sortDescriptors = sortDescriptors
        publicDataBase.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    func save(_ record: CKRecord, completion: @escaping ((Error?) -> Void) = { _ in }) {
        publicDataBase.save(record) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(error)
        }
    }
    func subscribeToCreationOfRecords(withType type: String, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        let subscription = CKQuerySubscription(recordType: type, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "New contact created"
        subscription.notificationInfo = notificationInfo
        publicDataBase.save(subscription) { (_, error) in
            if let error = error {
                NSLog("\(error)")
            }
            completion(error)
        }
    }

    func fetchUsername(for recordID: CKRecordID,
                       completion: @escaping ((_ givenName: String?, _ familyName: String?) -> Void) = { _,_ in }) {
        
        let recordInfo = CKUserIdentityLookupInfo(userRecordID: recordID)
        let operation = CKDiscoverUserIdentitiesOperation(userIdentityLookupInfos: [recordInfo])
        
        var userIdenties = [CKUserIdentity]()
        operation.userIdentityDiscoveredBlock = { (userIdentity, _) in
            userIdenties.append(userIdentity)
        }
        operation.discoverUserIdentitiesCompletionBlock = { (error) in
            if let error = error {
                NSLog("Error getting username from record ID: \(error)")
                completion(nil, nil)
                return
            }
            
            let nameComponents = userIdenties.first?.nameComponents
            completion(nameComponents?.givenName, nameComponents?.familyName)
        }
        
        CKContainer.default().add(operation)
    }
    
    func fetchAllDiscoverableUsers(completion: @escaping ((_ userInfoRecords: [CKUserIdentity]?) -> Void) = { _ in }) {
        
        let operation = CKDiscoverAllUserIdentitiesOperation()
        
        var userIdenties = [CKUserIdentity]()
        operation.userIdentityDiscoveredBlock = { userIdenties.append($0) }
        operation.discoverAllUserIdentitiesCompletionBlock = { error in
            if let error = error {
                NSLog("Error discovering all user identies: \(error)")
                completion(nil)
                return
            }
            
            completion(userIdenties)
        }
        
        CKContainer.default().add(operation)
    }
}

