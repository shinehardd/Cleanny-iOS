//
//  CharacterView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct CharacterView: View {
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
//        animation: .default)
//    private var users: FetchedResults<User>
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Clean.index, ascending: true)],
//        animation: .default)
//    private var cleans: FetchedResults<Clean>
    
    @EnvironmentObject var userData: UserDataStore
    @EnvironmentObject var cleaning: CleaningDataStore
    
    @Binding var index: Int
    @Binding var isCleaning: Bool
    
    @State private var isUpdatingView: Bool = true
    @State private var complateText = ""
    @State private var showModal = false
    
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color("MBackground").ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: { self.showModal = true })
                    {
                        Image("Setting")
                            .foregroundColor(Color("MBlue"))
                            .padding()
                    }
                    .sheet(isPresented: self.$showModal) {
                        SettingModalView(showModal: $showModal)
                    }
                }
                
                ZStack {
                    LottieView(name: isCleaning ? "Cleaning" : cleaning.charcterArr[index])
                    Text("\(complateText)")
                        .offset(y: -screenHeight / 5)
                }
                .frame(maxHeight: screenHeight / 2.5)
                
                CleaningCategoryProgress(index: $index, isCleaning: $isCleaning, complateText: $complateText)
                
                Spacer(minLength: screenHeight / 6)
            }
        }
//        .onChange(of: users[0].totalPercentage) { newValue in
//            isUpdatingView.toggle()
//        }
        .onChange(of: userData.totalPercentage) { newValue in
            isUpdatingView.toggle()
        }
    }
}
