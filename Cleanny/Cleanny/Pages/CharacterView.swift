//
//  CharacterView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct CharacterView: View {
    
    @EnvironmentObject var cleaning: CleaningDataStore
    
    @State private var complateText = ""
    @State private var showModal = false
    
    var filteredCleaning: [Cleaning] {
        cleaning.list.filter {category in
            category.activated
        }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let charcterArr = ["Cry", "Laugh", "Heit", "Love"]
    
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
                        SettingModalView()
                    }
                }
                Spacer()
                
                Text("\(complateText)")
                    .padding(.bottom)
                
                LottieView(charcterArr.randomElement()!)
                
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(filteredCleaning) {category in
                        ZStack {
                            CircularProgress()
                            CleaningButtonView(cleaning: category, complateText: $complateText)
                        }
                    }
                }
                Spacer(minLength:  150)
            }
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView()
            .environmentObject(CleaningDataStore())
    }
}
