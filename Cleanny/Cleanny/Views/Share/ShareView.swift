//
//  ShareView.swift
//  Cleanny
//
//  Created by 이채민 on 2022/06/10.
//

import SwiftUI
import CloudKit

struct ShareView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
        animation: .default)
    var user: FetchedResults<User>
    
    @EnvironmentObject private var viewModel: CloudkitUserViewModel
    
    @State private var me: CloudkitUser?
    @State private var friends: [String] = []
    @State private var percentageDic: [String:Double] = [:]
    
    @State private var isSharing = false
    @State private var isProcessingShare = false
    @State private var activeShare: CKShare?
    @State private var activeContainer: CKContainer?
    
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
                            if (me != nil) {
                                CardView(name: me!.name, percentage: me!.totalPercentage)
                                    .aspectRatio(10/13, contentMode: .fit)
                                    .padding(.horizontal)
                                    .padding(.top)
                                    .onTapGesture {
                                        alertTF(title: "닉네임 변경", message: "새로운 닉네임을 설정해주세요", hintText: "이름", primaryTitle: "저장", secondaryTitle: "취소") { text in
                                            me!.name = text
                                            let _ = print(me!.name)
                                            me!.setName(name: text)
                                            if (!user.isEmpty) {
                                                user[0].name = text
                                            }
                                            viewModel.updateUser(user: me!, name: text, totalPercentage: me!.totalPercentage)
                                        } secondaryAction: {}
                                    }
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
                        Text("공유").font(.headline).foregroundColor(Color("MBlack"))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(
                            action: { if (me != nil) {
                                Task {
                                    let _ = print(me!.name)
                                    try? await shareUser(me!)
                                }
                            } } , label: { Image(uiImage: UIImage(named: "AddFriend")!)
                                .foregroundColor(Color("MBlue")) }).buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $isSharing, content: { shareView() })
                    }
                }
            }
            .onAppear {
                Task {
                    try await viewModel.initialize()
                    try await viewModel.refresh()
                    try await loadFriends()
                }
            }
        }
    }
    
    private func loadFriends() async throws {

        switch viewModel.state {
            
        case let .loaded(me: me, friends: friends):
            
            if (me.isEmpty) {
                if (!user.isEmpty) {
                    try await viewModel.addUser(name: user[0].name ?? "이름을 입력해주세요", totalPercentage: user[0].totalPercentage)
                    try await viewModel.refresh()
                    try await loadFriends()
                } else {
                    try await viewModel.addUser(name: "이름을 입력해주세요", totalPercentage: 100)
                    try await viewModel.refresh()
                    try await loadFriends()
                }
            } else {
                self.me = me[0]
            }
            
            friends.forEach { friend in
                self.friends.append(friend.name)
                self.percentageDic[friend.name] = friend.totalPercentage
            }
            
        case .error(_):
            return
            
        case .loading:
            return
            
        }
    }
    
    private func shareUser(_ user: CloudkitUser) async throws {
        isProcessingShare = true
        try await viewModel.refresh()
        
        do {
            let (share, container) = try await viewModel.fetchOrCreateShare(user: user)
            isProcessingShare = false
            activeShare = share
            activeContainer = container
            isSharing = true
        } catch {
            debugPrint("Error sharing contact record: \(error)")
        }
    }
    
    private func shareView() -> CloudkitShareView? {
        guard let share = activeShare, let container = activeContainer else { return nil }
        
        return CloudkitShareView(container: container, share: share)
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

struct CardView: View {
    var name: String
    var percentage: Double
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: Color("ShadowBlue"), radius: 2, x: 0, y: 2)
            
            VStack {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color(percentage > 0.25 ? "MBlue" : "MRed").opacity(0.1))
                    Circle()
                        .fill(Color(percentage > 0.25 ? "MBlue" : "MRed").opacity(0.1))
                        .padding()
                    Circle()
                        .fill(Color(percentage > 0.25 ? "MBlue" : "MRed").opacity(0.1))
                        .padding()
                        .padding()
                    
                    Image(getCatImage(percentage: percentage))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth:100, maxWidth: 150)
                }
                .padding(.top)
                
                Text(name)
                    .bold().foregroundColor(Color("MBlack"))
                
                ProgressBar(percentage: percentage)
                    .padding([.bottom, .trailing, .leading])
            }
        }
    }
    
    private func getCatImage(percentage: Double) -> String {
        if (percentage > 0.75) {
            return "Love"
        } else if (percentage > 0.5) {
            return "Laugh"
        } else if (percentage > 0.25) {
            return "Cry"
        } else {
            return "Heit"
        }
    }
    
}

struct ProgressBar: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    var percentage: Double
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color("LGray"))
                    .frame(height: 14)
                    .overlay(
                        Capsule()
                            .stroke(.white, lineWidth: 4)
                            .shadow(color: Color("MBlack").opacity(0.2), radius: 4, x: 3, y: 4)
                            .clipShape(Capsule())
                            .shadow(color: .white.opacity(0.3), radius: 4, x: -3, y: -4)
                            .clipShape(Capsule())
                    )
                
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(percentage > 0.25 ? "GMBlue" : "GMRed"), Color(percentage > 0.25 ? "MBlue" : "MRed")]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 10)
                    .frame(maxWidth: geometry.size.width * percentage)
            }
        }
        .frame(height: 10)
    }
}

