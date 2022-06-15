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
            
                .gesture(
                    LongPressGesture(minimumDuration: 1.5)
                        .updating($tap) { currentState, gestureState, transaction in
                            gestureState = currentState
                        }
                        .onChanged { _ in
                            HapticManager.instance.impact(style: .heavy)
                            isCleaning = true
                        }
                        .onEnded { _ in
                            HapticManager.instance.notification(type: .success)
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
                        }
                )
        }
    }
}

//struct CleaningButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CleaningButtonView(cleaning: Cleaning(name: "분리수거", imageName: "DisposeTrash", activated: true, cycle: 3.0, decreaseRate: 3.0, currentPercent: 3.0), complateText: .constant("분리수거 완료 ✅"), progress: 3.0)
//            .previewLayout(.sizeThatFits)
//    }
//}
