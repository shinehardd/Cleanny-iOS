//
//  ChartPage5.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/15.
//
import SwiftUI
import SwiftUICharts

struct ChartPage5: View {
    
    @EnvironmentObject var MonthData: MonthDataStore
   
    var body: some View {

        BarChartView(data: ChartData(values:  MonthData.getMonthArr(month: MonthData.list[4])), title: MonthData.listKo[4].name  )
           
            .padding()
    }
}

