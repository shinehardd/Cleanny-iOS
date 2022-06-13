//
//  SettingCard.swift
//  Cleanny
//
//  Created by 한경준 on 2022/06/10.
//

import SwiftUI

struct SettingCard: View {
    
    @State var cleaningCategory: CleaningCategory
    
    var body: some View {
        
        Button(action: {
            cleaningCategory.activated.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(cleaningCategory.activated ? Color.white : Color("LGray"))
                    .shadow(color: cleaningCategory.activated ? Color("SBlue").opacity(0.4) : Color("MBlack").opacity(0.2), radius:4 , y:2
                    )
                
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/, height: 20)
                            .foregroundColor(cleaningCategory.activated ? Color("MBlue").opacity(0.8) : Color("DGray"))
                            .padding(7)
                    }
                    Image("\(cleaningCategory.imageName)")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(cleaningCategory.activated ? /*@START_MENU_TOKEN@*/Color("MBlue")/*@END_MENU_TOKEN@*/ : Color("DGray"))
                        .frame(width: 45, height: 45)
                    Spacer()
                    Text("\(cleaningCategory.name)")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DGray"))
                    Spacer()
                }
            }
        })
        .frame(width: 114, height: 140.0)
    }
}

struct SettingCard_Previews: PreviewProvider {
    static var previews: some View {
        SettingCard(cleaningCategory: cleaningCategories[0])
    }
}
