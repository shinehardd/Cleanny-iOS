//
//  ChartBarView.swift
//  Cleanny
//
//  Created by Hong jeongmin on 2022/06/15.
//

import SwiftUI
import SwiftUICharts

struct CharBarView: View {
    @EnvironmentObject var MonthData: MonthDataStore
    
    let idx: Int
    
    var body: some View {
        BarChartView(data: ChartData(values: MonthData.list[idx].arr), title: MonthData.listKo[idx].name )
            .padding()
    }
}

