//
//  RecordButton.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/15.
//

import SwiftUI

struct RecordButton: View {
    
    @ObservedObject var cleaning: Cleaning
    @Binding var index: Int
    
    var body: some View {
        Button(action: {
            print(cleaning.name)
            index = cleaning.index
        }, label: {
            Image(cleaning.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("MBlue"))
                .padding()
                .background(
                    Circle()
                        .foregroundColor(.white)
                        .shadow(color: Color("SBlue").opacity(0.3), radius: 5, x: 1, y: 1)
                )
        })
        .padding()
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton(cleaning: Cleaning(name: "분리수거", imageName:"DisposeTrash", activated: true, cycle: 3, decreaseRate:0.0003858, currentPercent: 99.999, index: 0), index: .constant(0))
            .frame(width: 85, height: 85)
    }
}
