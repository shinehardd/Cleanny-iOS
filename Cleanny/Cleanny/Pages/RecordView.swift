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
                HStack{
                ForEach(cleanings,id:\.self){
                    temp in
                   
                        Button(action:{}){
                            Circle().frame(width: 85, height: 85)
                                .foregroundColor(Color.white)
                                .overlay(Image(temp).foregroundColor(Color("MBlue")))
                        }
                    }}
            }
           
            HStack{Spacer()}
            Spacer(minLength: 150)
            
        }.background(Color("MBackground"))
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
