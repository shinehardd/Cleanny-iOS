//
//  CustomAlert.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/18.
//

import SwiftUI

struct CustomAlertView: View {
    
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var showAlert: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    
    var body: some View {
    
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            Text("변경할 이름을 입력해주세요")
                .bold()
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack(spacing: 20) {
                Button(action: {
                    self.showAlert = false
                    UIApplication.shared.endEditing()
                }, label: {
                    Text("취소")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color("MBlue")))
                })
                Button(action: {
                    self.showAlert = false
                    UIApplication.shared.endEditing()
                }, label: {
                    Text("저장")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color("MBlue")))
                })
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.3)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: showAlert ? 0 : screenSize.height)
        .animation(.spring(), value: showAlert)
        .shadow(color: Color("SBlue").opacity(0.3), radius: 6)

    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(title: "Add Item", showAlert: .constant(true), text: .constant(""))
    }
}
