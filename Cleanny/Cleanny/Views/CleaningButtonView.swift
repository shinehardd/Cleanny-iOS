//
//  CleaningButtonView.swift
//  Cleanny
//
//  Created by Hong jeongmin on 2022/06/10.
//

import SwiftUI

// https://github.com/Seogun95/HapticsView/blob/main/HapticsView/ContentView.swift
class HapticManager {
    
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct CleaningButtonView: View {
    @EnvironmentObject var monthData: MonthDataStore
    @ObservedObject var cleaning: Cleaning
    
    @GestureState var tap = false
    
    @Binding var isCleaning: Bool
    @Binding var complateText: String
    
    let progress: Double
    
    var body: some View {
        Button(action: {}) {
            Circle()
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .shadow(color: Color("SBlue").opacity(0.3), radius: 4, x: 1, y: 1)
                .scaleEffect(tap ? 1.1 : 1)
                .overlay(
                    Image(cleaning.imageName)
                        .foregroundColor(progress < 25 ? Color("MRed"): Color("MBlue"))
                )
                .onTapGesture {
                    isCleaning = false
                }
                .simultaneousGesture(LongPressGesture(minimumDuration: 1.5)
                    .onChanged { _ in
                        HapticManager.instance.impact(style: .heavy)
                        isCleaning = true
                    }
                                     
                    .onEnded{ _ in
                        HapticManager.instance.notification(type: .success)
                        monthData.addCnt(month: monthData.list[cleaning.index])
                        withAnimation {
                            complateText = cleaning.name + " 완료 ✅"
                            cleaning.currentPercent = 100
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                complateText = ""
                                isCleaning = false
                            }
                        }
                    })
        }
    }
}
