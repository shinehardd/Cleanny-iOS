//
//  CircularProgressView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/09.
//


import SwiftUI



struct CircularProgress: View {
    let minSize: CGFloat = 2;
    var lineWidth: CGFloat = 20
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: lineWidth)
                .frame(width: 80, height: 80)
            Circle()
                .trim(from: 0, to: progress * 0.01)
                .stroke(progress == 100 ? Color("Primary") : Color("Secondary"), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 80, height: 80)
//            GeometryReader { proxy in
//                ZStack {
//                    Color.clear
//                    HStack(alignment: .bottom, spacing: 0) {
//                        Text("\(Int(progress))")
//                            .foregroundColor(progress == 100 ? Color("Primary") :  Color("Secondary"))
//                            .font(.custom("Helvetica Bold", size: minSize * 0.2))
//                        Text("%")
//                            .foregroundColor(progress == 100 ? Color("Primary") :  Color("Secondary"))
//                            .font(.custom("Helvetica Bold", size: minSize * 0.1))
//                            .offset(y: -minSize * 0.3 * 0.09)
//                            .opacity(0.5)
//                    }
//                }
//            }
        }
        .padding(lineWidth / 2)
    }
}

struct CircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgress(progress: .constant(50))
    }
}
