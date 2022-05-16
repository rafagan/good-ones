//
//  ScaleTextSizeModifier.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI


struct ScaleTextSizeModifier: ViewModifier, Animatable {
    var name: String
    var size: Double

    var animatableData: Double {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(name, size: size))
    }
}
