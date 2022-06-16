//
//  RecordView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI


struct RecordView: View {
    
//    @EnvironmentObject var cleaning: CleaningDataStore
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Clean.index, ascending: true)],
        animation: .default)
    private var cleans: FetchedResults<Clean>
    
    @State var index: Int = 0
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            Spacer()
            
            CharBarView(idx: index)
            
            Spacer()
            
            LazyVGrid(columns: columns) {
//                ForEach(cleaning.list) {category in
//                    RecordButton(cleaning: category, index: $index)
//                }
                ForEach(cleans) {category in
                    RecordButton(cleaning: category, index: $index)
                }
            }
            .padding(.horizontal)
            
            Spacer(minLength: 120)
        }
        .background(Color("MBackground"))
    }
}
