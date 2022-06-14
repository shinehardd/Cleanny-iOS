//
//  ChartView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/10.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    @EnvironmentObject var MonthData: MonthDataStore
    @Binding var index: Int
    var demoData: ChartData = ChartData(points: [(37),(72),(51),(22),(39),(47)])
    
    var body: some View {
        
        BarChartView(data: ChartData(values: MonthData.list[index].arr), title: MonthData.listKo[index].name)
            .padding()
        //, legend: "Quarterly"
       // BarChartView(data: demoData, title: "chart")
            
          
    }
}
