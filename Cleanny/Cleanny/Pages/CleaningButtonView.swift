//
//  CleaningButtonView.swift
//  Cleanny
//
//  Created by Hong jeongmin on 2022/06/10.
//

import SwiftUI

struct CleaningButtonView: View {
    
    @ObservedObject var cleaning: Cleaning
    @Binding var complateText: String
    let progress: Double
    
    var body: some View {
        Button(action: {}) {
            Circle()
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .shadow(color: Color("MBlack").opacity(0.3), radius: 5, x: 1, y: 1)
                .overlay(
                    Image(cleaning.imageName)
                        .foregroundColor(progress < 25 ? Color("MRed"): Color("MBlue"))
                )
                .gesture(
                    LongPressGesture(minimumDuration: 2)
                        .onEnded { _ in
                            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                            impactMed.impactOccurred()
                            complateText = cleaning.name + " 완료 ✅"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                complateText = ""
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
