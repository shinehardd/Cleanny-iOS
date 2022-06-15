//
//  ChartPage3.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/15.
//


import SwiftUI
import SwiftUICharts

struct ChartPage3: View {
    
    @EnvironmentObject var MonthData: MonthDataStore
    
   
//    var arr: Array<(String,Double)> { MonthData.list[index].arr.filter{ Int($0.0)! < 7}}
    var body: some View {

        BarChartView(data: ChartData(values: MonthData.list[2].arr), title: MonthData.listKo[2].name )
           
            .padding()
    }
}

