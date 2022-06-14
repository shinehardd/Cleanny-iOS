//
//  MonthDataStore.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/14.
//


import Foundation

class MonthDataStore: ObservableObject {
    @Published var list: [Month]
    @Published var listKo: [Month]
    
    init() {
        list = [
            Month(name: "DisposeTrash"),
            Month(name: "Laundary"),
            Month(name: "ToiletCleaning"),
            Month(name: "FloorCleaning"),
            Month(name: "DishWashing"),
            Month(name: "TidyUp")
        ]
        
        listKo = [
            Month(name: "분리수거"),
            Month(name: "세탁"),
            Month(name: "욕실청소"),
            Month(name: "바닥청소"),
            Month(name: "설거지"),
            Month(name: "정리정돈")
        ]
    }
    
    func addCnt() {
        //        guard let cleaning = cleaning else {
        //            return
        //        }
        
        
    }
}
