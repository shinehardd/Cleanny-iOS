//
//  Cleaning.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/10.
//


import SwiftUI

struct Cleaning: Hashable {
    var name : String
    var cycle: Int
    var decreaseRate: Double
    var percentage: Double
    var activated : Bool
    
    
    
    init(name: String,cycle: Int, decreaseRate : Double, percentage : Double, activated : Bool){
        self.name = name
        self.cycle = cycle
        self.decreaseRate = decreaseRate
        self.percentage = percentage
        self.activated = activated
    }
    mutating func changeCycle(newCycle : Int){
        cycle = newCycle
        changeSpeed()
    }
    mutating func changeSpeed(){
        decreaseRate = 1/(Double(self.cycle)*864)
    }
    mutating func setPercentage(){
        percentage = percentage - decreaseRate
    }
    func getPrecentage() -> Double{
        return percentage
    }
}
    
var Cleanings : [Cleaning] = [Cleaning(name:"DisposeTrash",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
                              Cleaning(name:"Laundary",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
                              Cleaning(name:"ToiletCleaning",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
                              Cleaning(name:"FloorCleaning",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
                              Cleaning(name:"DishWashing",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
                              Cleaning(name:"TidyUp",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
                              
]
