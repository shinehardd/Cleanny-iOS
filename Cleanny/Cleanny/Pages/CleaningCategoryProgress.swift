//
//  MainCleaningCategory.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/12.
//

import SwiftUI

struct CleaningCategoryProgress: View {
    
    @EnvironmentObject var cleaning: CleaningDataStore
    
    @Binding var index: Int
    @Binding var isCleaning: Bool
    @Binding var complateText: String
    
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
                    CircularProgress(cleaning: category)
                    CleaningButtonView(cleaning: category, index: $index, isCleaning: $isCleaning, complateText: $complateText, progress: category.currentPercent)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MainCleaningCategory_Previews: PreviewProvider {
    static var previews: some View {
        CleaningCategoryProgress(index: .constant(0), isCleaning: .constant(true), complateText: .constant("분리수거 완료 ✅"))
            .environmentObject(CleaningDataStore())
    }
}
