//
//  OnboardingView.swift
//  Cleanny
//
//  Created by 한경준 on 2022/06/14.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var firstLaunching: Bool
    @State private var selection = 0
    
    var body: some View {
        ZStack {
            Color("MBackground").ignoresSafeArea()
            VStack {
                //온보딩 건너뛰기 버튼
                if selection<2 {
                    HStack {
                        Spacer()
                        //MARK: UI error
                        //건너뛰기 버튼 천천히 사라지는 문제 해결해야 함
                        Button {
                            withAnimation(.easeIn(duration: 1)){
                                selection = 2
                            }
                        } label: {
                            Text("건너뛰기")
                                .animation(nil)
                        }
                        
                        .foregroundColor(Color("MBlue"))
                    }
                    .padding(.horizontal)
                    .frame(height: 40.0)
                } else {
                    Spacer()
                        .frame(height: 50.0)
                }
                
                //온보딩 컨텐츠 페이지
                TabView(selection: $selection) {
                    ForEach(0..<3) { tagNum in
                        FirstOnboradingView(firstLaunching: $firstLaunching, number: tagNum + 1) .tag(tagNum)
                    }
                }
                .transition(.slide)
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                //다음, 시작하기 버튼
                Button {
                    withAnimation(.easeIn(duration: 1)){
                        if selection == 2 {
                            firstLaunching.toggle()
                        } else {
                            selection += 1
                        }
                    }
                } label: {
                    Text(selection == 2 ? "시작하기" : "다음")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color("MBlue"))
                        .cornerRadius(10)
                        //value 추가해야될듯 합니다
                        .animation(nil, value: selection)
                }
            }
        }
    }
}
//
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView(firstLaunching: true)
//    }
//}
