//
//  SettingSlider.swift
//  Cleanny
//
//  Created by 한경준 on 2022/06/10.
//

import SwiftUI

struct SettingSlider: View {
    
    @State var cleaningCategory: CleaningCategory
        
    var body: some View {
        HStack {
            //청소 아이콘
            Image("\(cleaningCategory.imageName)")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(cleaningCategory.activated ? Color("MBlue") : Color("MGray"))
                .frame(width: /*@START_MENU_TOKEN@*/24.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/24.0/*@END_MENU_TOKEN@*/)
            
            //청소 주기
            //여기에 ~일마다 라고 힌트가 좀 더 들어가도 괜찮을 듯. 슬라이더가 길다
            Text("\(Int(cleaningCategory.cycle))일")
                .foregroundColor(/*@START_MENU_TOKEN@*/Color("DGray")/*@END_MENU_TOKEN@*/)
                .frame(width: 30, height: /*@START_MENU_TOKEN@*/24.0/*@END_MENU_TOKEN@*/)
            
            //슬라이더
            Slider(value: $cleaningCategory.cycle, in: 1...7, step: 1)
                .accentColor(cleaningCategory.activated ? /*@START_MENU_TOKEN@*/Color("MBlue")/*@END_MENU_TOKEN@*/ : Color("MGray"))
                .disabled(!cleaningCategory.activated)
        }
        .padding(.vertical, 5.0)
    }
}

struct SettingSlider_Previews: PreviewProvider {
    static var previews: some View {
        SettingSlider(cleaningCategory: cleaningCategories[0])
    }
}
