//
//  CloudkitShareView.swift
//  Cleanny
//
//  Created by Jeon Jimin on 2022/06/15.
//

import Foundation
import SwiftUI
import UIKit
import CloudKit

struct CloudkitShareView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    
    let share: CKShare
    let container: CKContainer
    let User: User

    func makeCoordinator() -> CloudkitShareView.Coordinator {
        Coordinator()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeUIViewController(context: Context) -> some UIViewController {
        let sharingController = UICloudSharingController(share: share, container: container)
        sharingController.availablePermissions = [.allowReadWrite, .allowPrivate]
        sharingController.delegate = context.coordinator
        sharingController.modalPresentationStyle = .formSheet
        return sharingController
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
