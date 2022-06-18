//
//  User.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/10.
//

import Foundation
import CloudKit

struct CKUser: Identifiable {
    let id: String
    let name: String
    let totalPercentage: Double
    let associatedRecord: CKRecord
}

extension CKUser {
    /// Initializes a `Contact` object from a CloudKit record.
    /// - Parameter record: CloudKit record to pull values from.
    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let totalPercentage = record["totalPercentage"] as? Double else {
            return nil
        }

        self.id = record.recordID.recordName
        self.name = name
        self.totalPercentage = totalPercentage
        self.associatedRecord = record
    }
}
