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
    
    var calendar = Calendar.current
    var date = Date()
    var currentMonth = 0
    var temp: Int = 0
    
    init() {
        list = [
            Month(index: 0, name: "DisposeTrash"),
            Month(index: 1, name: "Laundary"),
            Month(index: 2, name: "ToiletCleaning"),
            Month(index: 3, name: "FloorCleaning"),
            Month(index: 4, name: "DishWashing"),
            Month(index: 5, name: "TidyUp")
        ]
        
        listKo = [
            Month(index: 0, name: "분리수거"),
            Month(index: 0, name: "세탁"),
            Month(index: 0, name: "욕실청소"),
            Month(index: 0, name: "바닥청소"),
            Month(index: 0, name: "설거지"),
            Month(index: 0, name: "정리정돈")
        ]
    }
    
    func addCnt(month: Month) {
        self.calendar = Calendar.current
        self.date = Date()
        self.currentMonth = Int(calendar.component(.month, from: date))
        
        temp = self.currentMonth - 1
        list[month.index].arr[temp].1 += 1
    }
    func getChartData(index: Int)->Array<(String,Double)>{
        self.calendar = Calendar.current
        self.date = Date()
        self.currentMonth = Int(calendar.component(.month, from: date))
        
        var chartData:Array<(String,Double)>{
            self.list[index].arr.filter(){
                month in Int(month.0)! <= self.currentMonth
            }
        }
        return chartData
    }
  
}
