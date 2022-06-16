//
//  CardView.swift
//  Cleanny
//
//  Created by Jeon Jimin on 2022/06/16.
//

import SwiftUI

struct CardView: View {
    var name: String
    var percentage: Double
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: Color("ShadowBlue"), radius: 2, x: 0, y: 2)
            
            VStack {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color(percentage > 0.25 ? "MBlue" : "MRed").opacity(0.1))
                    Circle()
                        .fill(Color(percentage > 0.25 ? "MBlue" : "MRed").opacity(0.1))
                        .padding()
                    Circle()
                        .fill(Color(percentage > 0.25 ? "MBlue" : "MRed").opacity(0.1))
                        .padding()
                        .padding()
                    
                    Image("Heit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth:100, maxWidth: 150)
                }
                .padding(.top)
                
                Text(name)
                    .bold()
                
                ProgressBar(percentage: percentage)
                    .padding([.bottom, .trailing, .leading])
            }
        }
    }
}
