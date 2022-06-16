//
//  ChartPage6.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/15.
//


import SwiftUI
import SwiftUICharts

struct ChartPage6: View {
    
    @EnvironmentObject var MonthData: MonthDataStore
    
    var body: some View {

        BarChartView(data: ChartData(values: MonthData.getChartData(index: 5)), title: MonthData.listKo[5].name )
           
            .padding()
    }
}
