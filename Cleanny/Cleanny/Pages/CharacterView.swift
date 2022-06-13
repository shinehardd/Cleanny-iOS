//
//  CharacterView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct CharacterView: View {
   
    
    @State private var complateText = ""
    @State private var showModal = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userData: UserDataStore

    let charcterArr = ["Cry", "Heit", "Laugh", "Love"]
    
    var body: some View {
        ZStack {
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
                Spacer()
                
                Text("\(complateText)")
                    .padding(.bottom)
                 
                LottieView(charcterArr[Int(userData.totalPercentage)/25])
                 
                    
                       
                Spacer()
                
                CleaningCategoryProgress(complateText: $complateText)
                Spacer(minLength:  150)
            }
        }
    }
}

//struct CharacterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterView()
//            .environmentObject(CleaningDataStore())
//    }
//}
