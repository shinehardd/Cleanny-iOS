//
//  Cleaning.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/10.
//


import Foundation
import SwiftUI

class Cleaning: Identifiable, ObservableObject {
    let id: UUID
    @Published var name: String
    @Published var imageName: String
    @Published var activated: Bool
    @Published var cycle: Double
    @Published var decreaseRate: Double
    @Published var currentPercent: Double
    @Published var savedTime : Date
    let index: Int
    
    init(name: String, imageName: String, activated: Bool, cycle: Double, decreaseRate: Double, currentPercent: Double, index: Int) {
        id = UUID()
        self.name = name
        self.imageName = imageName
        self.activated = activated
        self.cycle = cycle
        self.decreaseRate = decreaseRate
        self.currentPercent = currentPercent
        self.savedTime = Date()
        self.index = index
    }
    func percentCalculator(){
        let useTime = Int(Date().timeIntervalSince(self.savedTime))
        self.currentPercent = self.currentPercent - (Double(useTime)*self.decreaseRate)
        savedTime=Date()
        if(self.currentPercent < 0) {self.currentPercent = 0}
    }
    
}
