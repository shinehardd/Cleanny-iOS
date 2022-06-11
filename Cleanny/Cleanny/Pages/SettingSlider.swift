//
//  SettingSlider.swift
//  Cleanny
//
//  Created by 한경준 on 2022/06/10.
//

import SwiftUI

struct SettingSlider: View {
    //임시 슬라이더 값 변수
    //슬라이더가 Int값 말고 Double값만 쓰는 것 같습니다.
    @State var cycle = 3.0 //기본값 설정
    //슬라이더 활성화
    @State var activated: Bool = true
    //아이콘 이름
    @State var iconName: String = "DisposeTrash"

        
    var body: some View {
        HStack {
            //청소 아이콘
            Image("\(iconName)") //데이터 바꾸기
                .renderingMode(.template)
                .resizable()
                .foregroundColor(activated ? /*@START_MENU_TOKEN@*/Color("MBlue")/*@END_MENU_TOKEN@*/ : Color("MGray"))
                .frame(width: /*@START_MENU_TOKEN@*/24.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/24.0/*@END_MENU_TOKEN@*/)
            
            //청소 주기
            //여기에 ~일마다 라고 힌트가 좀 더 들어가도 괜찮을 듯. 슬라이더가 길다
            Text("\(Int(cycle))일")
                .foregroundColor(/*@START_MENU_TOKEN@*/Color("DGray")/*@END_MENU_TOKEN@*/)
                .frame(width: 30, height: /*@START_MENU_TOKEN@*/24.0/*@END_MENU_TOKEN@*/)
            
            //슬라이더
            Slider(value: $cycle, in: 1...7, step: 1)
                .accentColor(activated ? /*@START_MENU_TOKEN@*/Color("MBlue")/*@END_MENU_TOKEN@*/ : Color("MGray"))
                //activate가 안 되어 있으면 비활성화
                .disabled(!activated)
        }
        .padding(.vertical, 5.0)
    }
}

struct SettingSlider_Previews: PreviewProvider {
    static var previews: some View {
        SettingSlider()
    }
}
