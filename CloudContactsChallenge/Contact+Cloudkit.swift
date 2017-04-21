//
//  Contact+Cloudkit.swift
//  CloudContactsChallenge
//
//  Created by Clay Mills on 4/21/17.
//  Copyright © 2017 PineAPPle LLC. All rights reserved.
//

import Foundation
import CloudKit

extension Contact {
    
    init?(cloudKitRecord: CKRecord) {
        guard let name = cloudKitRecord[Keys.phoneNumberKey] as? String,
        let phoneNumber = cloudKitRecord[Keys.phoneNumberKey] as? String,
        let email = cloudKitRecord[Keys.phoneNumberKey] as? String,
            cloudKitRecord.recordType == Keys.contactRecordType else { return nil }
        self.init(name: name, phoneNumber: phoneNumber, email: email)
    }
    
    var cloudKitRecord: CKRecord {
        let record = CKRecord(recordType: Keys.contactRecordType)
        record[Keys.nameKey] = name as CKRecordValue?
        record[Keys.phoneNumberKey] = phoneNumber as CKRecordValue?
        record[Keys.emailKey] = email as CKRecordValue?
        return record 
    }
}
