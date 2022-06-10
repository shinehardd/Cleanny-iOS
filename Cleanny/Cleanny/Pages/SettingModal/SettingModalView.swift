//
//  SettingModalView.swift
//  Cleanny
//
//  Created by 한경준 on 2022/06/10.
//

import SwiftUI

struct SettingModalView: View {
    
    var body: some View {
        VStack {
            
            //일단은 다 하드코딩 해놨습니다.
            //청소 선택 - 주기 설정 간 활성화 연동 아직 구현 안 되어 있습니다.
            //청소 선택 토글 안 됩니다.- 구현중
            //청소 선택
            HStack {
                Text("청소 선택")
                    .font(.system(size: 24))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            HStack {
                SettingCard(name: "분리수거", iconName: "DisposeTrash")
                SettingCard(activated: false, name: "세탁", iconName: "Laundary")
                SettingCard(name: "욕실청소", iconName: "ToiletCleaning")
            }
            HStack {
                SettingCard(name: "바닥청소", iconName: "FloorCleaning")
                SettingCard(name: "설거지", iconName: "DishWashing")
                SettingCard(activated: false, name: "정리정돈", iconName: "TidyUp")
            }
            Spacer()
                .frame(height: 36)
            
            //주기 설정
            HStack {
                Text("주기 설정")
                    .font(.system(size: 24))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            Group {
                SettingSlider(cycle: 5, activated: true, iconName: "DisposeTrash")
                SettingSlider(cycle: 3, activated: false, iconName: "Laundary")
                SettingSlider(cycle: 1, activated: true, iconName: "ToiletCleaning")
                SettingSlider(cycle: 6, activated: true, iconName: "FloorCleaning")
                SettingSlider(cycle: 7, activated: true, iconName: "DishWashing")
                SettingSlider(cycle: 5, activated: false, iconName: "TidyUp")
            }
            //최하단 스페이서, 적절히 조절 필요
            Spacer()
                .frame(height: 36)
        }
        .padding(.horizontal)
        .background(Color("MBackground").edgesIgnoringSafeArea(.all))
    }
}

struct SettingModalView_Previews: PreviewProvider {
    static var previews: some View {
        SettingModalView()
    }
}
