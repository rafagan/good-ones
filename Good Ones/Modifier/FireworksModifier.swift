//
//  FireworkModifier.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

struct FireworksModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 5.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<80, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworksGeometryEffect(time: time))
                    .opacity( (duration - time) / duration )
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}
