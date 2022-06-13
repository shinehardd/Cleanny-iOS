//
//  SettingSliderView.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/11.
//

import SwiftUI

struct SettingSliderView: View {
    
    @EnvironmentObject var cleaning: CleaningDataStore
    
    var body: some View {
        VStack {
            ForEach(cleaning.list) {category in
                SettingSlider(cleaning: category)
            }
        }
    }
}

struct SettingSliderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingSliderView()
    }
}
