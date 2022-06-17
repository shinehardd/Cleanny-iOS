//
//  ShareView.swift
//  Cleanny
//
//  Created by 이채민 on 2022/06/10.
//

import SwiftUI
import CloudKit


struct ShareView: View {
    
    @EnvironmentObject var myData: UserDataStore
    
    @State private var isSharing = false
    @State private var isProcessingShare = false
    @State private var activeShare: CKShare?
    @State private var activeContainer: CKContainer?
    
    @State private var friends: [String] = []
    @State private var percentageDic: [String:Double] = [:]
//    @State private var me: CloudkitUser?
    @State private var showAlert: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
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
                            CardView(name: myData.name, percentage: myData.totalPercentage)
                                .aspectRatio(10/13, contentMode: .fit)
                                .padding(.horizontal)
                                .padding(.top)
                                .onTapGesture {
                                    alertTF(title: "닉네임 변경", message: "새로운 닉네임을 설정해주세요", hintText: "이름", primaryTitle: "저장", secondaryTitle: "취소") { text in
//                                        myData.name = text
//                                        me!.name = text
//                                        let _ = print(me!.name)
//                                        vm.updateUser(user: me!, name: myData.name, totalPercentage: myData.totalPercentage)
                                    } secondaryAction: {}
                                }
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
                        Button(action: {  }, label: { Image(uiImage: UIImage(named: "AddFriend")!)
                                .foregroundColor(Color("MBlue")) }).buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $isSharing, content: { /*shareView() */})
                    }
                }
            }
        }
        .onAppear {
            Task {
                
            }
        }
        .onReceive(timer) { time in
            
        }
    }
}

extension View {
    func alertTF(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String) -> (), secondaryAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = hintText
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .default, handler: { _ in
            secondaryAction()
        }))
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }))
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func rootController () -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return.init() }
        guard let root = screen.windows.first?.rootViewController else { return.init() }
        
        return root
    }
}
