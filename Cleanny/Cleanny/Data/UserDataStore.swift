//
//  UserDataStore.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/13.
//

import SwiftUI
import Foundation

class UserDataStore: Identifiable, ObservableObject {
    @Published var totalPercentage : Double
    
    var name : String
    var numerator : Double
    var denominator : Int
    
    init() {
        self.name = "이름을 설정해주세요"
        self.totalPercentage = 99
        self.numerator = 0
        self.denominator = 1
    }
    
    func update(cleaning : CleaningDataStore) -> Int{
        self.numerator = 0
        self.denominator = 0
        
        for oneCleaing in cleaning.list{
            if(oneCleaing.activated){
                self.numerator += oneCleaing.currentPercent
                self.denominator += 1
            }
        }
        
        self.totalPercentage = denominator == 0 ? -1 : (self.numerator / Double(self.denominator))
        return (Int(totalPercentage) / 25)
    }
}
