//
//  LoginView.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/18.
//

import SwiftUI

struct LoginView: View {
    // Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        NavigationView {
            if logStatus {
                ContentView()
                    .navigationBarHidden(true)
            }
            else {
                LoginPage()
                    .navigationBarHidden(true)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
