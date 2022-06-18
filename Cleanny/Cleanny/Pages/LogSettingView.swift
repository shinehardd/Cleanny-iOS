//
//  LogSettingView.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/18.
//

import SwiftUI
import Firebase

struct LogSettingView: View {
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("use_face_id") var useFaceID: Bool = false
    @AppStorage("use_face_email") var faceIDEmail: String = ""
    @AppStorage("use_face_password") var faceIDPassword: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Button {
                try? Auth.auth().signOut()
                logStatus = false
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("로그아웃")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .hCenter()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("MBlue"))
                    }
            }
            
            if useFaceID {
                Button {
                    useFaceID = false
                    faceIDEmail = ""
                    faceIDPassword = ""
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("페이스 아이디 해제하기")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .hCenter()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("MBlue"))
                        }
                }
            }
        }
    }
}

struct LogSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LogSettingView()
    }
}
