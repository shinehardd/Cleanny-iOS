//
//  RecordView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct RecordView: View {
    let arrays : [[String]]=[["DisposeTrash","Laundary","ToiletCleaning"],
                             ["FloorCleaning","DishWashing","TidyUp"]]
    
    var body: some View {
        VStack{
            Spacer()
            ChartView()
            Spacer()
            ForEach(arrays,id:\.self){
                cleanings in
                HStack (spacing: 30){
                    ForEach(cleanings,id:\.self){ temp in
                        Button(action:{}){
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 85, height: 85)
                                .shadow(color: Color("MBlack").opacity(0.3), radius: 5, x: 1, y: 1)
                                .overlay(Image(temp).foregroundColor(Color("MBlue")))
                        }
                    }
                }
                Spacer()
            }
            Spacer(minLength: 120)
            
        }.background(Color("MBackground"))
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
