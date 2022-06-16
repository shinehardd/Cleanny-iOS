//
//  SharingView.swift
//  Cleanny
//
//  Created by Jeon Jimin on 2022/06/16.
//

import SwiftUI
import CloudKit

struct SharingView: View {
    
    let sharingZone = CKRecordZone(zoneName: "com.apple.coredata.cloudkit.zone")
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>
    
    @State private var isSharing = false
    @State private var isProcessingShare = false
    @State private var activeShare: CKShare?
    @State private var activeContainer: CKContainer?
    
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
                            CardView(name: users[0].name ?? "", percentage: users[0].totalPercentage)
                                .aspectRatio(10/13, contentMode: .fit)
                                .padding(.horizontal)
                                .padding(.top)
                                .onTapGesture {
                                    alertTF(title: "닉네임 변경", message: "새로운 닉네임을 설정해주세요", hintText: "이름", primaryTitle: "저장", secondaryTitle: "취소") { text in
                                        users[0].name = text
//                                        me!.name = text
//                                        let _ = print(me!.name)
                                        updateUser()
                                    } secondaryAction: {}
                                }
                            ForEach(users, id: \.self) {
                                friend in
                                CardView(name: friend.name ?? "", percentage: friend.totalPercentage)
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
                        Button(action: {
                            Task { /*let _ = print(me!.name);t */ try? await shareUser(users[0]) }
                        }, label: { Image(uiImage: UIImage(named: "AddFriend")!)
                                    .foregroundColor(Color("MBlue")) }).buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $isSharing, content: { shareView(user: users[0]) })
                    }
                }
            }
        }
        .onAppear {
        }
        .onReceive(timer) { time in
//            if users[0] != nil {
//                users[0].totalPercentage = myData.totalPercentage
//            }
        }
    }
    /*
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
     */
    
    func fetchOrCreateShare(user: User) async throws -> (CKShare, CKContainer) {
        lazy var container = CKContainer(identifier: Config.containerIdentifier)
//        lazy var container = CKContainer.default().privateCloudDatabase
        lazy var privateDatabase = container.privateCloudDatabase
        
        let id = CKRecord.ID(zoneID: sharingZone.zoneID)
        let share = CKShare(rootRecord: CKRecord(recordType: "CD_User", recordID: id), shareID:id )
//        let share = CKShare(recordType: "User", recordID: id)
        
        share[CKShare.SystemFieldKey.title] = "User: \(user.name ?? "" )"
        let userRecord = CKRecord(recordType: "CD_User", recordID: id)
//        _ = try await privateDatabase.modifyRecords(saving: [userRecord], deleting: []) //왜 modifyRecords를 불러오는거지? 이거 실행하면 CD_User 추가됨
        
        
        return (share, container)
    }
    
    private func shareUser(_ user: User) async throws {
        isProcessingShare = true
        do {
            let (share, container) = try await fetchOrCreateShare(user: user)
            isProcessingShare = false
            activeShare = share
            activeContainer = container
            isSharing = true
        } catch {
            debugPrint("Error sharing contact record: \(error)")
        }
    }
    
    private func shareView(user: User) -> CloudkitShareView? {
        guard let share = activeShare, let container = activeContainer else { return nil }
        
        return CloudkitShareView(share: share, container: container, User: user)
    
    }
    
    func updateUser() {
        do {
            try viewContext.save()
        }catch{
            viewContext.rollback()
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

struct SharingView_Previews: PreviewProvider {
    static var previews: some View {
        SharingView()
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

enum Config {
    static let containerIdentifier = "iCloud.com.Loudy.Cleanny.elie"
}

