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
    var coreDataStack = CoreDataStack()
    
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
                            if (!UserDefaults.standard.bool(forKey: "notDoneSetting")) {
                                CardView(name: user[0].name!, percentage: user[0].totalPercentage)
                                    .aspectRatio(10/13, contentMode: .fit)
                                    .padding(.horizontal)
                                    .padding(.top)
                                    .onTapGesture {
                                        alertTF(title: "닉네임 변경", message: "새로운 닉네임을 설정해주세요", hintText: "이름", primaryTitle: "저장", secondaryTitle: "취소") { text in
                                            user[0].name = text
                                            coreDataStack.save()
                                        } secondaryAction: {}
                                    }
                            }
//                            ForEach(friends, id: \.self) {
//                                friend in
//                                CardView(name: friend, percentage: percentageDic[friend]!)
//                                    .aspectRatio(10/13, contentMode: .fit)
//                                    .padding(.horizontal)
//                                    .padding(.top)
//                            }
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
                        Button(action: { Task { if(!UserDefaults.standard.bool(forKey: "notDoneSetting")) { try? await shareUser(user[0]) }} }, label: { Image(uiImage: UIImage(named: "AddFriend")!)
                                .foregroundColor(Color("MBlue")) }).buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $isSharing, content: { shareView() })
                    }
                }
            }
        }
        .onAppear {
            Task {
//                try await vm.initialize()
//                try await vm.refresh()
//                try await loadFriends()
            }
        }
    }
    
//    private func updateUser() {
//        do {
//            try viewContext.save()
//        } catch  {
//            viewContext.rollback()
//        }
//    }
    
    
    private func loadFriends() async throws {

    }
    
    private func shareUser(_ user: User) async throws {
        isProcessingShare = true
        coreDataStack.save()
        let container = CoreDataStack.shared.ckContainer
        let share = coreDataStack.getShare(user)
        isProcessingShare = false
        activeShare = share
        activeContainer = container
        isSharing = true
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

