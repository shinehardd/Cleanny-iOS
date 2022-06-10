//
//  CleaningButtonView.swift
//  Cleanny
//
//  Created by Hong jeongmin on 2022/06/10.
//

import SwiftUI

struct CleaningButtonView: View {
    let cleaningItem: Cleaning
    
    var body: some View {
        Button(action: {}) {
            Circle()
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .shadow(color: Color("ShadowB"), radius: 5, x: 1, y: 1)
                .overlay(
                    Image(cleaningItem.name)
                        .foregroundColor(Color("MBlue"))
                )
                .gesture(
                    LongPressGesture(minimumDuration: 2)
                        .onEnded { _ in
                            print(cleaningItem.name)
                        }
                )
        }
    }
}
