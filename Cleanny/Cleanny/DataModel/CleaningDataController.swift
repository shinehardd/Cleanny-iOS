//
//  CleaningDataController.swift
//  Cleanny
//
//  Created by Hong jeongmin on 2022/06/18.
//

import Foundation
import CoreData

class CleaningDataController: ObservableObject {
    let container = NSPersistentContainer(name: "CleannyModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load data \(error.localizedDescription)")
            }
        }
        
        
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("We cloud not save the data...")
        }
    }
    
    func initCleaning(context: NSManagedObjectContext) {
        let cleaning = CleaningData(context: context)
        let cleaningName = ["DisposeTrash", "Laundary", "ToiletCleaning", "FloorCleaning", "DishWashing", "TidyUp"]
        
        (cleaningName).forEach { name in
            cleaning.id = UUID()
            cleaning.cleaningType = name
            cleaning.characterState = 100
            cleaning.cleaingState = 100
            cleaning.actived = true
            cleaning.cycle = 1
            cleaning.decreaseRate = 30
        }
        save(context: context)
    }
    
    func updateCleaning(cleaning: CleaningData, actived: Bool, cycle: Int64, characterState: Double, decreaseRate: Double, cleaingState: Double, context: NSManagedObjectContext) {
        cleaning.cleaingState = cleaingState
        cleaning.characterState = characterState
        cleaning.decreaseRate = decreaseRate
        cleaning.cycle = cycle
        cleaning.actived = actived
        
        save(context: context)
    }
}
