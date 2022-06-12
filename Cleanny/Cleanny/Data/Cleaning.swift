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
    @Published var activated: Bool
    @Published var cycle: Double
    @Published var decreaseRate: Double
    
    init(name: String, activated: Bool, cycle: Double, decreaseRate: Double) {
        id = UUID()
        self.name = name
        self.activated = activated
        self.cycle = cycle
        self.decreaseRate = decreaseRate
    }
}
