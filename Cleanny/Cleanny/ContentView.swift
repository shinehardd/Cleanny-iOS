//
//  ContentView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI
import CoreData
import AxisTabView

struct ContentView: View {
    
    @AppStorage("firstLaunching") var firstLaunching: Bool = true
    @AppStorage("isDoneSetting") var isDoneSetting: Bool = false

    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var cleaning: CleaningDataStore
    @EnvironmentObject var userData: UserDataStore
    
    @State var index: Int = 3
    @State private var isUpdatingView: Bool = false
    @State private var selection: Int = 0
    @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init(normalSize: CGSize(width: 50, height: 80)))
    @State private var cornerRadius: CGFloat = 26
    @State private var radius: CGFloat = 30
    @State private var depth: CGFloat = 0.8
    @State private var color: Color = .accentColor
    @State private var marbleColor: Color = .accentColor
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { proxy in
            AxisTabView(selection: $selection, constant: constant) { state in
                if constant.axisMode == .bottom {
                    TabStyle(state,
                             color: Color("MBlue"),
                             cornerRadius: cornerRadius,
                             marbleColor: Color("MBlue"),
                             radius: radius,
                             depth: depth)
                }
            } content: {
                ControlView(index: $index,
                            selection: $selection,
                            constant: $constant,
                            cornerRadius: $cornerRadius,
                            radius: $radius,
                            depth: $depth,
                            color: $color,
                            marbleColor: $marbleColor,
                            tag: 0,
                            systemName: "Home",
                            safeArea: proxy.safeAreaInsets)
                ControlView(index: $index,
                            selection: $selection,
                            constant: $constant,
                            cornerRadius: $cornerRadius,
                            radius: $radius,
                            depth: $depth,
                            color: $color,
                            marbleColor: $marbleColor,
                            tag: 1,
                            systemName: "Chart",
                            safeArea: proxy.safeAreaInsets)
                ControlView(index: $index,
                            selection: $selection,
                            constant: $constant,
                            cornerRadius: $cornerRadius,
                            radius: $radius,
                            depth: $depth,
                            color: $color,
                            marbleColor: $marbleColor,
                            tag: 2,
                            systemName: "Share",
                            safeArea: proxy.safeAreaInsets)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .animation(.easeInOut, value: constant)
        .animation(.easeInOut, value: radius)
        .animation(.easeInOut, value: depth)
        .animation(.easeInOut, value: marbleColor)
        .animation(.easeInOut, value: cornerRadius)
        .navigationTitle("Screen \(selection + 1)")
        .onReceive(timer) { time in
            for index in 0...5 {
                cleaning.list[index].percentCalculator()
            }
            self.index = userData.update(cleaning: cleaning)
            isUpdatingView.toggle()
        }
        .fullScreenCover(isPresented: $firstLaunching) {
            OnboardingView(firstLaunching: $firstLaunching)
        }
        .onAppear {
            if (UserDefaults.standard.bool(forKey: "notDoneSetting")) {
                addNewUser()
            }
        }
    }
    
    private func addNewUser() {

        let newUser = User(context: viewContext)
        newUser.name = "이름을 설정해주세요"
        newUser.totalPercentage = 99.9
        newUser.denomirator = 1
        newUser.numerator = 1

       do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        UserDefaults.standard.set(false, forKey: "notDoneSetting")
    }
    
    struct ControlView: View {
        
        @Binding var index:Int
        @Binding var selection: Int
        @Binding var constant: ATConstant
        @Binding var cornerRadius: CGFloat
        @Binding var radius: CGFloat
        @Binding var depth: CGFloat
        @Binding var color: Color
        @Binding var marbleColor: Color
        
        @State var isCleaning = false
        
        let tag: Int
        let systemName: String
        let safeArea: EdgeInsets
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(.white)
                switch(tag){
                case 0 :
                    CharacterView(index: $index, isCleaning: $isCleaning)
                case 1:
                    RecordView()
                case 2 :
                    ShareView()
                default:
                    CharacterView(index: $index, isCleaning: $isCleaning)
                }
            }
            .tabItem(tag: tag, normal: {
                TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: false, systemName: systemName)
            }, select: {
                TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: true, systemName: systemName)
            })
        }
        
        private func empty(name: String, totalPercentage: Double) async throws {}
        
    }
    
    struct TabButton: View {
        
        @Binding var constant: ATConstant
        @Binding var selection: Int
                
        @State private var y: CGFloat = 0

        let tag: Int
        let isSelection: Bool
        let systemName: String
        
        var content: some View {
            ZStack(alignment: .leading) {
                Image(uiImage: UIImage(named: systemName)!)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 24))
                    .padding(10)
            }
            .foregroundColor(isSelection ? Color.white : Color("Unselected"))
            .clipShape(Capsule())
            .offset(y: y)
            .onAppear {
                if isSelection {
                    withAnimation(.easeInOut(duration: 0.3).delay(0.25)) {
                        y = constant.axisMode == .top ? -18 : 18
                    }
                    withAnimation(.easeInOut(duration: 0.3).delay(0.4)) {
                        y = constant.axisMode == .top ? -15 : 15
                    }
                } else {
                    y = 0
                }
            }
        }
        
        var body: some View {
            content
        }
    }
}
