//
//  View.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI


extension View {
    func animatableFont(name: String, size: Double) -> some View {
        self.modifier(ScaleTextSizeModifier(name: name, size: size))
    }
}
