//
//  Month.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/14.
//

import Foundation
import SwiftUI

class Month: Identifiable, ObservableObject {
    
    @Published var name: String
    @Published var arr: Array<(String,Double)> = [("1",0),("2",0),("3",0),("4",0),("5",0),("6",0),("7",0),("8",0),("9",0),("10",0),("11",0),("12",0)]
    
    let id: UUID
    let index: Int
    
    init(index: Int, name: String) {
        id = UUID()
        self.index = index
        self.name = name
    }
}
