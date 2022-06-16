//
//  RecordButton.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/15.
//

import SwiftUI

struct RecordButton: View {
    
//    @ObservedObject var cleaning: Cleaning
    @ObservedObject var cleaning: Clean
    
    @Binding var index: Int
    
    var body: some View {
        Button(action: {
            index = Int(cleaning.index)
        }) {
            Image(cleaning.imageName ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("MBlue"))
                .padding()
                .background(
                    Circle()
                        .foregroundColor(.white)
                        .shadow(color: Color("SBlue").opacity(0.3), radius: 5, x: 1, y: 1)
                )
        }
        .padding()
    }
}
