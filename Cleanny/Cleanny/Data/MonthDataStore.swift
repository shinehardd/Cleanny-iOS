//
//  MonthDataStore.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/14.
//


import Foundation

class MonthDataStore: ObservableObject {
    @Published var list: [Month]
   
    init() {
        list = [Month(name: "DisposeTrash"),
                Month(name: "Laundary"),
                Month(name: "ToiletCleaning"),
                Month(name: "FloorCleaning"),
                Month(name: "DishWashing"),
                Month(name: "TidyUp")
           
        ]
    }
    
    func addCnt() {
//        guard let cleaning = cleaning else {
//            return
//        }
        

    }
}
