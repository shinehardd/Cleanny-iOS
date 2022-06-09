//
//  ChartView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/10.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    var demoData: ChartData = ChartData(points: [37,72,51,22,39,47,66,85,50])
    
    var body: some View {
        BarChartView(data: demoData, title: "chart")
            
          
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
