//
//  CharacterView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct CharacterView: View {
    @State private var complateText = ""
    
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
            
            Text("\(complateText)")
                .padding(.bottom)
            
            Image(systemName: "plus").resizable()
                .frame(width: 320, height: 200)
            
            Spacer()
            
            VStack (spacing: 20){
                ForEach(CleaningData, id:\.self) { row in
                    HStack (spacing: 20) {
                        ForEach(row, id:\.self) { cleaningItem in
                            ZStack {
                                CircularProgress()
                                CleaningButtonView(complateText: $complateText, cleaningItem: cleaningItem)
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
