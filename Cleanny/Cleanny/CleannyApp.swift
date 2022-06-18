//
//  CleannyApp.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

@main
struct CleannyApp: App {
    @StateObject private var cleaningDataController = CleaningDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, cleaningDataController.container.viewContext)
        }
    }
}
