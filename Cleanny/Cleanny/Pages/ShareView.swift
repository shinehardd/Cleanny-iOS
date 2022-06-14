//
//  ShareView.swift
//  Cleanny
//
//  Created by 이채민 on 2022/06/10.
//

import SwiftUI
import CloudKit

struct ShareView: View {
    
    @EnvironmentObject private var vm: CloudkitUserViewModel
    @State private var isSharing = false
    @State private var activeShare: CKShare?
    @State private var activeContainer: CKContainer?
    
    @State private var friends: [String] = []
    @State private var percentageDic: [String:Double] = [:]
    @State var friendCount = 1
    
//    var friends = ["주주", "쿠키", "치콩", "엘리", "할로겐", "네이스", "버킬", "창브로", "밀키"]
//    var percentageDic = ["주주": 0.8, "쿠키": 0.6, "치콩": 0.3, "엘리": 0.2, "할로겐": 1, "네이스": 0.7, "버킬": 0.5, "창브로": 0.1, "밀키": 0.9]

    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: -18, alignment: nil),
        GridItem(.flexible(), spacing: -18, alignment: nil)
    ]
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("MBackground")
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    ScrollView(showsIndicators: false) {
                        LazyVGrid (columns: columns,
                                    alignment: .center,
                                    spacing: nil,
                                    pinnedViews: [],
                                    content: {
//                                switch vm.state {
//                                case let .loaded(me, friends):
//                                    let _ = DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//                                        CardView(name: me[0].name, percentage: me[0].totalPercentage)
//                                            .aspectRatio(10/13, contentMode: .fit)
//                                            .padding(.horizontal)
//                                            .padding(.top)
//                                        ForEach(friends) {
//                                            friend in CardView(name: friend.name, percentage: friend.totalPercentage)
//                                                .aspectRatio(10/13, contentMode: .fit)
//                                                .padding(.horizontal)
//                                                .padding(.top)
//                                        }
//                                    }
//                                case .error(let error):
//                                    VStack {
//                                        Text("ERROR \(error.localizedDescription)")
//                                    }
//                                case .loading:
//                                    VStack { EmptyView() }
//                                }
                            ForEach(friends, id: \.self) {
                                friend in
                                CardView(name: friend, percentage: percentageDic[friend]!)
                                    .aspectRatio(10/13, contentMode: .fit)
                                    .padding(.horizontal)
                                    .padding(.top)
                            }
                        })
                        Spacer(minLength: 50)
                    }
                    Spacer(minLength: 60)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        Text("공유").font(.headline)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // 친구 추가 모달 or 알림
                        } label: {
                            Image(uiImage: UIImage(named: "AddFriend")!)
                                .foregroundColor(Color("MBlue"))
                        }
                    }
                }
            }
            
        }
        .onAppear {
            Task {
                try await vm.initialize()
                try await vm.refresh()
                loadFriends()
            }
        }
    }
    
    private func loadFriends() {
        switch vm.state {

        case let .loaded(me, friends):
            me.forEach { me in
                self.friends.append(me.name)
                self.percentageDic[me.name] = me.totalPercentage
            }
//            self.friends.append(me[0].name)
//            self.percentageDic[me[0].name] = me[0].totalPercentage
            friends.forEach({ friend in
                self.friends.append(friend.name)
                self.percentageDic[friend.name] = friend.totalPercentage
                friendCount+=1
            })

        case .error(_):
            return

        case .loading:
            VStack { EmptyView() }
        }
    }
    
}

struct CardView: View {
    var name: String
    var percentage: Double
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: Color("ShadowBlue"), radius: 2, x: 0, y: 2)
            VStack(alignment: .center) {
                ZStack {
                    if percentage > 0.25 {
                        Circle()
                            .fill(Color("MBlue").opacity(0.1))
                            .frame(width: 130, height: 140, alignment: .center)
                        Circle()
                            .fill(Color("MBlue").opacity(0.1))
                            .frame(width: 110, height: 120, alignment: .center)
                        Circle()
                            .fill(Color("MBlue").opacity(0.1))
                            .frame(width: 90, height: 100, alignment: .center)
                    } else {
                        Circle()
                            .fill(Color("MRed").opacity(0.1))
                            .frame(width: 130, height: 140, alignment: .center)
                        Circle()
                            .fill(Color("MRed").opacity(0.1))
                            .frame(width: 110, height: 120, alignment: .center)
                        Circle()
                            .fill(Color("MRed").opacity(0.1))
                            .frame(width: 90, height: 100, alignment: .center)
                    }
                }
                Text(name)
                    .font(.system(size: 16))
                ProgressBar(percentage: percentage)
                    .frame(height: 10, alignment: .center)
            }
            
        }
    }
}

struct ProgressBar: View {
    var percentage: Double
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 9)
                .fill(Color("LGray"))
                .frame(width: 134, height: 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 9) // main circle innerShadow
                        .stroke(.white, lineWidth: 4)
                        .shadow(color: Color("MBlack").opacity(0.2), radius: 4, x: 3, y: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                        .shadow(color: .white.opacity(0.3), radius: 4, x: -3, y: -4)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                )
            if percentage > 0.25 {
                RoundedRectangle(cornerRadius: 9)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("GMBlue"), Color("MBlue")]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 130 *  CGFloat(percentage), height: 10)
            } else {
                RoundedRectangle(cornerRadius: 9)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("GMRed"), Color("MRed")]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 130 *  CGFloat(percentage), height: 10)
            }
            
        }
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView()
    }
}
