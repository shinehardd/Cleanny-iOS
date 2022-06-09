//
//  CharacterView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//

import SwiftUI

struct CharacterView: View {
    var body: some View {
        VStack{
            //캐릭터자리
            HStack{
                CircularProgress(progress: .constant(50))
                CircularProgress(progress: .constant(50))
                CircularProgress(progress: .constant(50))
            }
            HStack{
                CircularProgress(progress: .constant(50))
                CircularProgress(progress: .constant(50))
                CircularProgress(progress: .constant(50))
            }
            
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView()
    }
}
