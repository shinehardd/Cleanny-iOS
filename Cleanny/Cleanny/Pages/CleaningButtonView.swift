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
    @Binding var complateText: String
    @Binding var isCleaning: Bool
    
    @GestureState var tap = false
    
    let cleaningItem: Cleaning
    
    var body: some View {
        Circle()
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .shadow(color: Color("SBlue").opacity(0.3), radius: 4, x: 1, y: 1)
            .scaleEffect(tap ? 1.1 : 1)
            .overlay(
                Image(cleaningItem.name)
                    .foregroundColor(Color("MBlue"))
            )
            .onTapGesture {
                isCleaning = false
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: 1.5)
                .updating($tap) { currentState, gestureState, transition in
                    gestureState = currentState
                }
                                 
                .onChanged { _ in
                    HapticManager.instance.impact(style: .heavy)
                    isCleaning = true
                }
                                 
                .onEnded{ _ in
                    HapticManager.instance.notification(type: .success)
                    withAnimation {
                        complateText = cleaningItem.getKoreanName() + " 완료 ✅"
                        //cleaning.currentPercent = 100
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        complateText = ""
                        isCleaning = false
                    }
                }
            )
    }
}
