//
//  MainCleaningCategory.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/12.
//

import SwiftUI

struct CleaningCategoryProgress: View {
    
    @Binding var complateText: String
    @EnvironmentObject var cleaning: CleaningDataStore
    
    var filteredCleaning: [Cleaning] {
            cleaning.list.filter {category in
            category.activated
        }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(filteredCleaning) {category in
                ZStack {
                    CircularProgress()
                    CleaningButtonView(cleaning: category, complateText: $complateText, progress: category.currentPercent)
                }
            }
        }
    }
}

struct MainCleaningCategory_Previews: PreviewProvider {
    static var previews: some View {
        CleaningCategoryProgress(complateText: .constant("분리수거 완료 ✅"))
            .environmentObject(CleaningDataStore())
    }
}
