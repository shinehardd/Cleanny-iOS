//
//  SettingModalView.swift
//  Cleanny
//
//  Created by 한경준 on 2022/06/10.
//

import SwiftUI

struct SettingModalView: View {
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("완료")
                        .modalButton()
                    
                }
                .padding(.bottom, 10)
                
                Text("청소 선택")
                    .modalTitle()
                
                CleaningCategoryView()
                Spacer(minLength: 30)
                
                Text("주기 설정")
                    .modalTitle()
                
                SettingSliderView()
                Spacer()
            }
            .padding()
        }
    }
}

extension Text {
    
    func modalTitle() -> some View {
        self.foregroundColor(Color("MBlack"))
            .font(.system(size: 24))
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
    }
    
    func modalButton() -> some View {
        self.foregroundColor(Color("SBlue"))
            .font(.system(size: 16))
            .fontWeight(.semibold)
    }
}

struct SettingModalView_Previews: PreviewProvider {
    static var previews: some View {
        SettingModalView()
    }
}

