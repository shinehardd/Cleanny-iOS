//
//  UserViewModel.swift
//  Cleanny
//
//  Created by Jeon Jimin on 2022/06/18.
//

import Foundation
import CloudKit
import OSLog

@MainActor
final class UserViewModel: ObservableObject {
    
    // MARK: - Error

    enum ViewModelError: Error {
        case invalidRemoteShare
    }

    // MARK: - State

    enum State {
        case loading
        case loaded(private: [CKUser], shared: [CKUser])
        case error(Error)
    }
    
    @Published private(set) var state: State = .loading
    lazy var container = CKContainer(identifier: Config.containerIdentifier)
    private lazy var database = container.privateCloudDatabase
    let recordZone = CKRecordZone(zoneName: "UserZone")

    // MARK: - Init

    nonisolated init() {}

    init(state: State) {
        self.state = state
    }

    // MARK: - API
    func initialize() async throws {
        do {
            try await createZoneIfNeeded()
        } catch {
            state = .error(error)
        }
    }

    /// Fetches CKUsers from the remote databases and updates local state.
    func refresh() async throws {
        state = .loading
        do {
            let (privateUsers, sharedUsers) = try await fetchPrivateAndSharedUsers()
            state = .loaded(private: privateUsers, shared: sharedUsers)
        } catch {
            state = .error(error)
        }
    }

    /// Fetches both private and shared CKUsers in parallel.
    /// - Returns: A tuple containing separated private and shared contacts.
    func fetchPrivateAndSharedUsers() async throws -> (private: [CKUser], shared: [CKUser]) {
        // This will run each of these operations in parallel.
        async let privateUsers = fetchUsers(scope: .private, in: [recordZone])
        async let sharedUsers = fetchSharedUsers()

        return (private: try await privateUsers, shared: try await sharedUsers)
    }

    /// Adds a new Contact to the database.
    /// - Parameters:
    ///   - name: Name of the Contact.
    ///   - totalPercentage: totalPercentage of the contact.
    func addUser(name: String, totalPercentage: Double) async throws {
        let id = CKRecord.ID(zoneID: recordZone.zoneID)
        let userRecord = CKRecord(recordType: "CKUser", recordID: id)
        userRecord["name"] = name
        userRecord["totalPercentage"] = totalPercentage

        try await database.save(userRecord)
    }
    func updateUser(user: CKUser, name: String, totalPercentage: Double) {
        let userRecord = user.associatedRecord
        userRecord["name"] = name
        userRecord["totalPercentage"] = totalPercentage
        
        database.save(userRecord) { returnedRecord, returnedError in
            print("Record: \(String(describing: returnedRecord))")
            print("Error: \(String(describing: returnedError))")
        }
    }

    /// Fetches an existing `CKShare` on a Contact record, or creates a new one in preparation to share a Contact with another user.
    /// - Parameters:
    ///   - user: CKUser to share.
    ///   - completionHandler: Handler to process a `success` or `failure` result.
    func fetchOrCreateShare(user: CKUser) async throws -> (CKShare, CKContainer) {
        guard let existingShare = user.associatedRecord.share else {
            let share = CKShare(rootRecord: user.associatedRecord)
            share[CKShare.SystemFieldKey.title] = "\(user.name)의 청소상태를 공유받으세요"
            _ = try await database.modifyRecords(saving: [user.associatedRecord, share], deleting: [])
            return (share, container)
        }

        guard let share = try await database.record(for: existingShare.recordID) as? CKShare else {
            throw ViewModelError.invalidRemoteShare
        }

        return (share, container)
    }

    // MARK: - Private

    /// Fetches CKUsers for a given set of zones in a given database scope.
    /// - Parameters:
    ///   - scope: Database scope to fetch from.
    ///   - zones: Record zones to fetch contacts from.
    /// - Returns: Combined set of contacts across all given zones.
    private func fetchUsers(
        scope: CKDatabase.Scope,
        in zones: [CKRecordZone]
    ) async throws -> [CKUser] {
        let database = container.database(with: scope)
        var allContacts: [CKUser] = []

        // Inner function retrieving and converting all Contact records for a single zone.
        @Sendable func usersInZone(_ zone: CKRecordZone) async throws -> [CKUser] {
            var allUsers: [CKUser] = []

            /// `recordZoneChanges` can return multiple consecutive changesets before completing, so
            /// we use a loop to process multiple results if needed, indicated by the `moreComing` flag.
            var awaitingChanges = true
            /// After each loop, if more changes are coming, they are retrieved by using the `changeToken` property.
            var nextChangeToken: CKServerChangeToken? = nil

            while awaitingChanges {
                let zoneChanges = try await database.recordZoneChanges(inZoneWith: zone.zoneID, since: nextChangeToken)
                let users = zoneChanges.modificationResultsByID.values
                    .compactMap { try? $0.get().record }
                    .compactMap { CKUser(record: $0) }
                
                allUsers.append(contentsOf: users)

                awaitingChanges = zoneChanges.moreComing
                nextChangeToken = zoneChanges.changeToken
            }

            return allUsers
        }

        // Using this task group, fetch each zone's contacts in parallel.
        try await withThrowingTaskGroup(of: [CKUser].self) { group in
            for zone in zones {
                group.addTask {
                    try await usersInZone(zone)
                }
            }

            // As each result comes back, append it to a combined array to finally return.
            for try await usersResult in group {
                allContacts.append(contentsOf: usersResult)
            }
        }

        return allContacts
    }

    /// Fetches all shared Contacts from all available record zones.
    private func fetchSharedUsers() async throws -> [CKUser] {
        let sharedZones = try await container.sharedCloudDatabase.allRecordZones()
        guard !sharedZones.isEmpty else {
            return []
        }

        return try await fetchUsers(scope: .shared, in: sharedZones)
    }

    /// Creates the custom zone in use if needed.
    private func createZoneIfNeeded() async throws {
        // Avoid the operation if this has already been done.
        guard !UserDefaults.standard.bool(forKey: "isZoneCreated") else {
            return
        }

        do {
            _ = try await database.modifyRecordZones(saving: [recordZone], deleting: [])
        } catch {
            print("ERROR: Failed to create custom zone: \(error.localizedDescription)")
            throw error
        }

        UserDefaults.standard.setValue(true, forKey: "isZoneCreated")
    }
}
