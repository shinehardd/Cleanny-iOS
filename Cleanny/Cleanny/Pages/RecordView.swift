//
//  RecordView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//


import SwiftUI

struct RecordView: View {
    
    var body: some View {
        VStack{
            Spacer()
            ChartView()
            Spacer()
            HStack{
                Button(action:{}){
                    Circle().frame(width: 60, height: 60)
                        .foregroundColor(Color.white)
                        .overlay(Image("DisposeTrash").foregroundColor(Color("MBlue")))
                }
                Button(action:{}){
                    Circle().frame(width: 60, height: 60)
                        .foregroundColor(Color.white)
                        .overlay(Image("Laundary").foregroundColor(Color("MBlue")))
                    
                }

                Button(action:{}){
                    Circle().frame(width: 60, height: 60)
                        .foregroundColor(Color.white)
                        .overlay(Image("ToiletCleaning").foregroundColor(Color("MBlue")))
                }

            }
            HStack{
                Button(action:{}){
                    Circle().frame(width: 60, height: 60)
                        .foregroundColor(Color.white)
                        .overlay(Image("FloorCleaning").foregroundColor(Color("MBlue")))
                }
                Button(action:{}){
                    Circle().frame(width: 60, height: 60)
                        .foregroundColor(Color.white)
                        .overlay(Image("DishWashing").foregroundColor(Color("MBlue")))
                }

                Button(action:{}){
                    Circle().frame(width: 60, height: 60)
                        .foregroundColor(Color.white)
                        .overlay(Image("TidyUp").foregroundColor(Color("MBlue")))
                }

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
