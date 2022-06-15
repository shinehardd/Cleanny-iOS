//
//  FirstOnboradingView.swift
//  Cleanny
//
//  Created by 한경준 on 2022/06/15.
//

import SwiftUI

struct FirstOnboradingView: View {
    @Binding var firstLaunching: Bool

    var number = 1
    
    var body: some View {
        Button("\(number)") {}
        .foregroundColor(.white)
        .frame(width: 300, height: 50)
        .background(Color("MBlue"))
        .cornerRadius(10)
    }
}
