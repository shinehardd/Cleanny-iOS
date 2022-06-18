//
//  CloudSharingView.swift
//  Cleanny
//
//  Created by Jeon Jimin on 2022/06/18.
//

import Foundation
import SwiftUI
import UIKit
import CloudKit

/// This struct wraps a `UICloudSharingController` for use in SwiftUI.
struct CloudSharingView: UIViewControllerRepresentable {

    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode
    let container: CKContainer
    let share: CKShare

    // MARK: - UIViewControllerRepresentable

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeUIViewController(context: Context) -> some UIViewController {
        let sharingController = UICloudSharingController(share: share, container: container)
        sharingController.availablePermissions = [.allowReadOnly, .allowPublic]
        sharingController.delegate = context.coordinator
        sharingController.modalPresentationStyle = .none
        return sharingController
    }

    func makeCoordinator() -> CloudSharingView.Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UICloudSharingControllerDelegate {
        func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
            debugPrint("Error saving share: \(error)")
        }

        func itemTitle(for csc: UICloudSharingController) -> String? {
            "Sharing Example"
        }
    }
}
