//
//  ShareView.swift
//  Cleanny
//
//  Created by 이채민 on 2022/06/10.
//

import SwiftUI
import CloudKit


struct ShareView: View {
    @State private var isAddingUser = false
    @State private var isSharing = false
    @State private var isProcessingShare = false

    @State private var activeShare: CKShare?
    @State private var activeContainer: CKContainer?
    
    @State private var me: CKUser?
    
//    @EnvironmentObject var myData: UserDataStore
    
    @EnvironmentObject private var vm: UserViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>
    
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
//                            CardView(name: myData.name, percentage: myData.totalPercentage)
//                                .aspectRatio(10/13, contentMode: .fit)
//                                .padding(.horizontal)
//                                .padding(.top)
//                                .onTapGesture {
//                                    alertTF(title: "닉네임 변경", message: "새로운 닉네임을 설정해주세요", hintText: "이름", primaryTitle: "저장", secondaryTitle: "취소") { text in
//                                        updateUser(name: text)
//                                    } secondaryAction: {}
//                                }
                            switch vm.state {
                            case let .loaded(privateCKUsers, sharedCKUsers):
                                VStack {
                                    Text("loaded")
                                    ForEach(privateCKUsers) { user in
                                        let _ = me = user
                                        CardView(name: user.name, percentage: user.totalPercentage)
                                            .aspectRatio(10/13, contentMode: .fit)
                                            .padding(.horizontal)
                                            .padding(.top)
                                    }
                                    
                                    ForEach(sharedCKUsers) { user in
                                        CardView(name: user.name, percentage: user.totalPercentage)
                                            .aspectRatio(10/13, contentMode: .fit)
                                            .padding(.horizontal)
                                            .padding(.top)
                                    }
                                }

                            case .error(let error):
                                VStack {
                                    Text("An error occurred: \(error.localizedDescription)").padding()
                                    Spacer()
                                }

                            case .loading:
                                Text("loading")
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
                        Button(action: { Task { try? await shareUser(me!) } },
                               label: { Image(uiImage: UIImage(named: "AddFriend")!)
                                .foregroundColor(Color("MBlue")) }).buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $isSharing, content: { shareView()})
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button { Task { try await vm.refresh() } } label: { Image(systemName: "arrow.clockwise") }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        progressView
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await vm.initialize()
                try await vm.refresh()
            }
        }
        .onReceive(timer) { time in
            
        }
    }
    var progressView: some View {
        let showProgress: Bool = {
            if case .loading = vm.state {
                return true
            } else if isProcessingShare {
                return true
            }

            return false
        }()

        return Group {
            if showProgress {
                ProgressView()
            }
        }
    }
    func updateUser(name: String){
        
//        myData.name = name
        //cloud update TODO: cloud update함수 작성 필요 CKUser어떻게 받아오지?
//        vm.updateUser(user: me!, name: name, totalPercentage: myData.totalPercentage)
        //coredata update
        users[0].name = name
        do {
            try viewContext.save()
        }catch {
            viewContext.rollback()
        }
    }
    func loadUser(){
        switch vm.state {
        case let .loaded(privateCKUsers, sharedCKUsers):
            List {
                Section(header: Text("Private")) {
                    ForEach(privateCKUsers) { privateCKUser in
                        
                    }
                }
                Section(header: Text("Shared")) {
                    ForEach(sharedCKUsers) { sharedCKUser in
                        
                    }
                }
            }.listStyle(GroupedListStyle())

        case .error(let error):
            VStack {
                Text("An error occurred: \(error.localizedDescription)").padding()
                Spacer()
            }
        case .loading:
            Text("loading")
        }
    }
    private func shareView() -> CloudSharingView? {
        guard let share = activeShare, let container = activeContainer else {
            return nil
        }
        return CloudSharingView(container: container, share: share)
    }
    private func shareUser(_ user: CKUser) async throws {
        isProcessingShare = true
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
