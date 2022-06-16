//
//  FirstOnboradingView.swift
//  Cleanny
//
//  Created by 한경준 on 2022/06/15.
//

import SwiftUI

struct FirstOnboradingView: View {
    @Binding var firstLaunching: Bool

    var number = 1
        
    var body: some View {
        //온보딩 컨텐츠
        VStack {
            Spacer()
            Text("온보딩\(number)번 페이지")
            Spacer()
            //인디케이터용 스페이서
            Spacer()
                .frame(height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
        }
    }
}
