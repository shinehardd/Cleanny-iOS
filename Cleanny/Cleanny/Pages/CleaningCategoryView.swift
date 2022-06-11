//
//  CleaningCategoryView.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/11.
//

import SwiftUI

struct CleaningCategoryView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(cleaningCategories) {category in
                SettingCard(cleaningCategory: category)
            }
        }
    }
}

struct CleaningCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CleaningCategoryView()
    }
}
