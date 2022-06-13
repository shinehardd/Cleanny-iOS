//
//  ChartView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/10.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    var demoData: ChartData = ChartData(points: [(37),(72),(51),(22),(39),(47)])
    
    var body: some View {
        
        BarChartView(data: ChartData(values: [("1",37), ("2",73), ("3",51), ("4",22), ("5",39), ("6",47)]), title: "Sales")
        //, legend: "Quarterly"
       // BarChartView(data: demoData, title: "chart")
            
          
    }
}
