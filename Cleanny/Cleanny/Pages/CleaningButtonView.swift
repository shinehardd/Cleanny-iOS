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
    
    @ObservedObject var cleaning: Cleaning
    @Binding var complateText: String
    @GestureState var tap = false
    
    let progress: Double
    
    var body: some View {
        Button(action: {}) {
            Circle()
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .shadow(color: Color("MBlack").opacity(0.3), radius: 5, x: 1, y: 1)
                .scaleEffect(tap ? 1.1 : 1)
                .overlay(
                    Image(cleaning.imageName)
                        .foregroundColor(progress < 25 ? Color("MRed"): Color("MBlue"))
                )
                .gesture(
                    LongPressGesture(minimumDuration: 2).updating($tap) { currentState, gestureState, transaction in
                        gestureState = currentState
                        
                    }
                        .onEnded { _ in
                            HapticManager.instance.notification(type: .warning)
                            withAnimation {
                                complateText = cleaning.name + " 완료 ✅"
                                cleaning.currentPercent = 100
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    complateText = ""

                                }
                                
                            }
                        }
                )
        }
    }
}
//
//struct CleaningButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CleaningButtonView(cleaning: Cleaning(name: "분리수거", imageName: "DisposeTrash", activated: true, cycle: 3.0, decreaseRate: 3.0), complateText: .constant("분리수거 완료 ✅"))
//            .previewLayout(.sizeThatFits)
//    }
//}
