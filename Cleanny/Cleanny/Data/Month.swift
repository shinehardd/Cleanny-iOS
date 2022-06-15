//
//  Month.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/14.
//

import Foundation
import SwiftUI

class Month: Identifiable, ObservableObject {
    
    let id: UUID
    @Published var name: String
    @Published var arr: Array<(String,Double)> = [("",0),("",0),("",0),("",0),("",0),("",0)]
    var calendar = Calendar.current
    var date = Date()
    var currentMonth: Int {calendar.component(.month, from: date)}
    var temp: Int = 0
    
    init(name: String) {
        id = UUID()
        self.name = name
        for i in 0...5{
            temp = (currentMonth-i)
            if(temp < 1) {temp += 12}
            arr[5-i] = ("\(temp)",1)
        }
        
    }
}
