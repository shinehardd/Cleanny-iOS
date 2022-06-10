//
//  CharacterView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct CharacterView: View {
    
    // 임시 데이터
    var CleaningData : [[Cleaning]] = [
        
        [
            Cleaning(name:"DisposeTrash",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
            Cleaning(name:"Laundary",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
            Cleaning(name:"ToiletCleaning",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true)
        ],
        [
            Cleaning(name:"FloorCleaning",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
            Cleaning(name:"DishWashing",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true),
            Cleaning(name:"TidyUp",cycle: 3, decreaseRate:0.0003858, percentage: 100, activated: true)
        ],
        
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "plus").resizable()
                .frame(width: 320, height: 200)
            
            Spacer()
            
            VStack (spacing: 20){
                ForEach(CleaningData, id:\.self) { row in
                    HStack (spacing: 20) {
                        ForEach(row, id:\.self) { cleaningItem in
                            ZStack {
                                CircularProgress(progress: .constant(Double(Int.random(in: 0...100))))
                                Button(action: {
                                    // 임시 확인
                                    print(cleaningItem.name)
                                }) {
                                    Circle()
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color("ShadowB"), radius: 5, x: 1, y: 1)
                                        .overlay(
                                            Image(cleaningItem.name)
                                                .foregroundColor(Color("MBlue"))
                                        )
                                }
                            }
                        }
                    }
                }
            }
            Spacer(minLength:  150)
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView()
    }
}
