//
//  CharacterView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct CharacterView: View {
    @Binding var check : Bool
    @Binding var index : Int
    
    @State private var complateText = ""
    @State private var showModal = false
    @EnvironmentObject var userData: UserDataStore
    var characterIndex : Int{self.index}
    var temp = -10

//    let charcterArr = ["Cry", "Heit", "Laugh", "Love"]
    
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
                  Text("\(index)")
                LottieView(index: $index, loopMode: loop)
                 
                    
                       
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
