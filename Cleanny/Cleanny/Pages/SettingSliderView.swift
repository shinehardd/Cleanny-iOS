//
//  SettingSliderView.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/11.
//

import SwiftUI

struct SettingSliderView: View {
    var body: some View {
        VStack {
            ForEach(cleaningCategories) {category in
                SettingSlider(cleaningCategory: category)
            }
        }
    }
}

struct SettingSliderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingSliderView()
    }
}
