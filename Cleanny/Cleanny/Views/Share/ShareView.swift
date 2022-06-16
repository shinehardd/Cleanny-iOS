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
    @EnvironmentObject var myData: UserDataStore
    
    @State private var isSharing = false
    @State private var isProcessingShare = false
    @State private var activeShare: CKShare?
    @State private var activeContainer: CKContainer?
    @State private var friends: [String] = []
    @State private var percentageDic: [String:Double] = [:]
    @State private var me: CloudkitUser?
    @State private var showAlert: Bool = false
    @State var isEditMode: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let onAdd: ((String, Double) async throws -> Void)?
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: -15),
        GridItem(.flexible(), spacing: -15)
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
                            
                            ForEach(friends, id: \.self) {
                                friend in
                                CardView(name: friend, percentage: percentageDic[friend]!)
                                    .aspectRatio(10/13, contentMode: .fit)
                                    .padding(.horizontal)
                                    .padding(.top)
                                    .overlay(alignment: .topLeading) {
                                        Button(action: {
                                            print("delete")
                                        }, label: {
                                            Image(systemName: "minus.circle.fill")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.red)
                                        })
                                        .opacity(isEditMode ? 1 : 0)
                                        .padding()
                                        .offset(x: 8, y: 8)
                                    }
                                    .rotationEffect(.degrees(isEditMode ? 2.5 : 0))
                                    .animation(.easeInOut(duration: isEditMode ? 0.25 : 0).repeatForever(autoreverses: isEditMode), value: isEditMode)
                                    .onLongPressGesture(minimumDuration: 1.5, maximumDistance: 50.0) {
                                        isEditMode = true
                                    }
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
                        if isEditMode == true {
                            Button(action: {
                                isEditMode.toggle()
                            }, label: {
                                Text("완료")
                                    .foregroundColor(Color("SBlue"))
                                    .bold()
                            })
                        } else {
                            Button(action: { Task { let _ = print(me!.name)
                                try? await shareUser(me!) } }, label: { Image(uiImage: UIImage(named: "AddFriend")!)
                                    .foregroundColor(Color("MBlue")) }).buttonStyle(BorderlessButtonStyle())
                                .sheet(isPresented: $isSharing, content: { shareView() })
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await vm.initialize()
                if me == nil {
                    print("망함")
                    try await vm.addUser(name: myData.name, totalPercentage: myData.totalPercentage)
                }
                try await vm.refresh()
                try await loadFriends()
            }
        }
        .onReceive(timer) { time in
            if me != nil {
                me!.totalPercentage = myData.totalPercentage
            }
        }
    }
    
    private func loadFriends() async throws {
        switch vm.state {
        case let .loaded(me, friends):
            self.me = me.last!
            
            friends.forEach({ friend in
                self.friends.append(friend.name)
                self.percentageDic[friend.name] = friend.totalPercentage
            })
        case .error(_):
            return
        case .loading:
            return
        }
    }
    
    private func shareUser(_ user: CloudkitUser) async throws {
        isProcessingShare = true
        
        try await vm.refresh()
        
        do {
            let (share, container) = try await vm.fetchOrCreateShare(user: user)
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
                    
                    Image("Heit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth:100, maxWidth: 150)
                }
                .padding(.top)
                
                Text(name)
                    .bold()
                
                ProgressBar(percentage: percentage)
                    .padding([.bottom, .trailing, .leading])
            }
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

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(name: "주주", percentage: 0.8)
    }
}
