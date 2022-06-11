//
//  CleannyApp.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

@main
struct CleannyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SettingModalView()
//            ContentView()
               // .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
