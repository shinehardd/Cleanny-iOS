//
//  CleaningDataStore.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/12.
//

import Foundation

class CleaningDataStore: ObservableObject {
    @Published var list: [Cleaning]
    
    init() {
        list = [
            Cleaning(name:"DisposeTrash", activated: true, cycle: 3, decreaseRate:0.0003858),
            Cleaning(name:"Laundary", activated: true, cycle: 3, decreaseRate:0.0003858),
            Cleaning(name:"ToiletCleaning", activated: true, cycle: 3, decreaseRate:0.0003858),
            Cleaning(name:"FloorCleaning", activated: true, cycle: 3, decreaseRate:0.0003858),
            Cleaning(name:"DishWashing", activated: true, cycle: 3, decreaseRate:0.0003858),
            Cleaning(name:"TidyUp", activated: true, cycle: 3, decreaseRate:0.0003858)
        ]
    }
    
    func update(cleaning: Cleaning?, activated: Bool, cycle: Double, decreaseRate: Double) {
        guard let cleaning = cleaning else {
            return
        }
        
        cleaning.activated = activated
        cleaning.cycle = cycle
        cleaning.decreaseRate = decreaseRate
        
    }
}
