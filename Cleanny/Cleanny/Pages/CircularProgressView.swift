//
//  CircularProgressView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/09.
//


import SwiftUI


struct CircularProgress: View {
    
    @Binding var progress: Double
    var lineWidth: Double = 20
    
    var body: some View {
        
        let angularGradientProgress = AngularGradient(
            gradient: Gradient(colors: [progress <= 25 ? Color("GMRed") : Color("GMBlue"), progress <= 25 ? Color("MRed") : Color("MBlue")]),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(3.6 * progress))
        
        ZStack {
            Circle()
                .frame(width: 98.5, height: 98.5)
                .foregroundColor(Color("LGray"))
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 4)
                        .shadow(color: Color("MBlack").opacity(0.2), radius: 4, x: 3, y: 4)
                        .clipShape(Circle())
                        .shadow(color: .white.opacity(0.6), radius: 4, x: 3, y: -4)
                        .clipShape(Circle())
                )
            
            Circle()
                .foregroundColor(.white)
                .frame(width: CGFloat(95.5 - lineWidth), height: CGFloat(95.5 - lineWidth))
            
            Circle()
                .trim(from: 0, to: CGFloat(self.progress * 0.01))
                .stroke(angularGradientProgress, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 85, height: 85)
            
            Circle()
                .frame(width: 98.5, height: 98.5)
                .foregroundColor(.clear)
                .overlay(
                    Circle()
                        .trim(from: 0, to: CGFloat(self.progress * 0.01))
                        .stroke(.white.opacity(0.4), lineWidth: 4)
                        .rotationEffect(Angle(degrees: -90))
                        .shadow(color: .white, radius: 2, x: 3, y: 4)
                        .clipShape(Circle().trim(from: 0, to: CGFloat(self.progress * 0.01)))
                )
            
            Circle()
                .trim(from: 0, to: CGFloat(self.progress * 0.01))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: -90))
                .shadow(color: .white.opacity(0.4), radius: 2, x: 3, y: 4)
                .frame(width: CGFloat(95.5 - lineWidth), height: CGFloat(95.5 - lineWidth))
            
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(Color("MBlue"))
        }
    }
}

struct CircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgress(progress: .constant(50))
    }
}
