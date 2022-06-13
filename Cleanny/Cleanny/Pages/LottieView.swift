//
//  LottieView.swift
//  Cleanny
//
//  Created by Jung Yunseong on 2022/06/12.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    @Binding var index: Int
    let charcterArr = ["Cry", "Heit", "Laugh", "Love"]
    typealias UIViewType = UIView
    var filename: String{charcterArr[index]}
    var loopMode: LottieLoopMode
   
    init(_ jsonName: String = "Best",
         _ loopMode: LottieLoopMode = .loop) {
        self.filename="Best"
        self.loopMode = loopMode
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
}
