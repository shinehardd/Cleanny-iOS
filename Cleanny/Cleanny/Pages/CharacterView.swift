//
//  CharacterView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct CharacterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
                        .offset(y: -screenHeight/5)
                }
                .frame(maxHeight: screenHeight/2.5)

                CleaningCategoryProgress(isCleaning: $isCleaning, index: $index, complateText: $complateText)
                Spacer(minLength: screenHeight/6)
            }
        }
        .onChange(of: userData.totalPercentage) { newValue in
            isUpdatingView.toggle()
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(index: .constant(0), isCleaning: .constant(true))
            .environmentObject(CleaningDataStore())
            .environmentObject(UserDataStore())
    }
}
