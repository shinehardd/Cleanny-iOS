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
            VStack {
                HStack {
                    Spacer()
                    Text("완료")
                        .foregroundColor(Color("SBlue"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 10)
                
                //청소 선택 - 주기 설정 간 활성화 연동 아직 구현 안 됨
                //청소 선택 최소 개수 설정 필요
                
                //청소 선택
                HStack {
                    Text("청소 선택")
                        .foregroundColor(Color("MBlack"))
                        .font(.system(size: 24))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                
                CleaningCategoryView()
                Spacer()
                
                //주기 설정
                HStack {
                    Text("주기 설정")
                        .foregroundColor(Color("MBlack"))
                        .font(.system(size: 24))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                Group {
                    //슬라이더 초기 설정값 지정 필요
                    //카드 false되었을 때 슬라이더 값은 유지?
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
        }
    }
}

struct SettingModalView_Previews: PreviewProvider {
    static var previews: some View {
        SettingModalView()
    }
}

