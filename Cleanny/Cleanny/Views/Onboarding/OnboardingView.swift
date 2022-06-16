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
    //페이지 개수 설정
    let numberOfPage:Int = 4
    
    var body: some View {
        ZStack {
            Color("MBackground").ignoresSafeArea()
            VStack {
                //온보딩 건너뛰기 버튼
                if selection<(numberOfPage-1) {
                    HStack {
                        Spacer()
                        //MARK: UI error
                        //건너뛰기 버튼 천천히 사라지는 문제 해결해야 함
                        Button {
                            withAnimation(.easeIn(duration: 1)){
                                selection = (numberOfPage-1)
                            }
                        } label: {
                            Text("건너뛰기")
                                .animation(nil)
                        }
                        
                        .foregroundColor(Color("MBlue"))
                    }
                    .padding(.horizontal)
                    .frame(height: 42.0)
                } else {
                    Spacer()
                        .frame(height: 50.0)
                }
                
                //온보딩 컨텐츠 페이지
                TabView(selection: $selection) {
                    ForEach(0..<numberOfPage) { tagNum in
                        FirstOnboradingView(firstLaunching: $firstLaunching, number: tagNum + 1) .tag(tagNum)
                    }
                }
                .transition(.slide)
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                //다음, 시작하기 버튼
                Button {
                    withAnimation(.easeIn(duration: 1)){
                        if selection == (numberOfPage-1) {
                            firstLaunching.toggle()
                        } else {
                            selection += 1
                        }
                    }
                } label: {
                    Text(selection == (numberOfPage-1) ? "시작하기" : "다음")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.semibold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width-60, height: 60)
                        .background(Color("MBlue"))
                        .cornerRadius(10)
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
