//
//  UserDataStore.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/13.
//

import SwiftUI
import Foundation

class UserDataStore: Identifiable, ObservableObject {
   
    
       var name : String
       @Published var totalPercentage : Double
       //분자
       var numerator : Double
       //분모
       var denominator : Int
 
    init() {
        self.name = ""
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
            else{
                
            }
            
        }
        if(denominator == 0){
            self.totalPercentage = -1
        }
        else{
            self.totalPercentage = (self.numerator / Double(self.denominator))
        }
        return (Int(totalPercentage) / 25)
    }
}
