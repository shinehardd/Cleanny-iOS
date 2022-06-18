//
//  LoginPage.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/18.
//

import SwiftUI

struct LoginPage: View {
    @StateObject var loginModel: LoginViewModel = LoginViewModel()
    
    // MARK: FaceID Properties
    @State var useFaceID: Bool = false
    var body: some View {
        
        ZStack {
            Color("MBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text("로그인 해주세요")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color("MBlack"))
                    .hLeading()
                
                // MARK: Textfields
                TextField("이메일", text: $loginModel.email)
                    .padding()
                    .background {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                loginModel.email == "" ? Color.black.opacity(0.05) : Color("LSkyBlue")
                            )
                    }
                    .textInputAutocapitalization(.never)
                    .padding(.top,20)
                
                SecureField("암호", text: $loginModel.password)
                    .padding()
                    .background {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                loginModel.password == "" ? Color.black.opacity(0.05) : Color("LSkyBlue")
                            )
                    }
                    .textInputAutocapitalization(.never)
                    .padding(.top,15)
                
                // MARK: User Prompt to ask to store Login using FaceID on next time
                if loginModel.getBioMetricStatus(){
                    
                    Group{
                        
                        if loginModel.useFaceID{
                            
                            Button {
                                // MARK: Do FaceID Action
                                Task{
                                    do{
                                        try await loginModel.authenticateUser()
                                    }
                                    catch{
                                        loginModel.errorMsg = error.localizedDescription
                                        loginModel.showError.toggle()
                                    }
                                }
                            } label: {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Label {
                                    
                                        Text("페이스 아이디를 이용해 로그인을 해주세요")
                                    } icon: {
                                        
                                        Image(systemName: "faceid")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    
                                    Text("팁: 설정에서 페이스 아이디를 삭제할 수 있습니다.")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .hLeading()

                        }
                        else{
                            Toggle(isOn: $useFaceID) {
                                Text("다음부터 페이스 아이디 사용하기")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical,20)
                }
                
                Button {
                    Task{
                        do{
                            try await loginModel.loginUser(useFaceID: useFaceID)
                        }
                        catch{
                            loginModel.errorMsg = error.localizedDescription
                            loginModel.showError.toggle()
                        }
                    }
                } label: {
                    
                    Text("로그인")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .hCenter()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("MBlue"))
                        }
                }
                .padding(.vertical,35)
                .disabled(loginModel.email == "" || loginModel.password == "")
                .opacity(loginModel.email == "" || loginModel.password == "" ? 0.5 : 1)

                NavigationLink {
                    ContentView()
                        .navigationBarHidden(true)
                } label: {
                    Text("건너뛰기")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal,25)
            .padding(.vertical)
            .alert(loginModel.errorMsg, isPresented: $loginModel.showError) {
                
            }
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}

// MARK: Extensions for UI Designing
extension View{
    
    func hLeading()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    func hTrailing()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .trailing)
    }
    
    func hCenter()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .center)
    }
}
