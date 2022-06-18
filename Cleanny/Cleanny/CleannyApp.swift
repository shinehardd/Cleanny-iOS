//
//  CleannyApp.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI
import Firebase

@main
struct CleannyApp: App {
    @StateObject var cleaning =  CleaningDataStore()
    @StateObject var userData = UserDataStore()
    @StateObject var MonthData = MonthDataStore()
    let persistenceController = PersistenceController.shared

    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
//            ContentView()
                .environmentObject(cleaning)
                .environmentObject(userData)
                .environmentObject(MonthData)
               // .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
