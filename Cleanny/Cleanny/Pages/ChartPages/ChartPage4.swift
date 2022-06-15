//
//  ChartPage4.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/15.
//

import SwiftUI
import SwiftUICharts

struct ChartPage4: View {
    
    @EnvironmentObject var MonthData: MonthDataStore
    

    var body: some View {

        BarChartView(data: ChartData(values: MonthData.list[3].arr), title: MonthData.listKo[3].name )
           
            .padding()
    }
}