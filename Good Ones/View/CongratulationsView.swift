//
//  CongratulationsView.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

struct CongratulationsView: View {
    @State private var fontSize = 12.0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 12, height: 12)
                .modifier(FireworksModifier())
                .offset(x: -100, y : -50)
            
            Circle()
                .fill(Color.red)
                .frame(width: 12, height: 12)
                .modifier(FireworksModifier())
                .offset(x: 60, y : 70)
            
            Text("All done for today. Come back later 🥰.")
                .animatableFont(name: "Bradley Hand", size: fontSize)
                .onAppear {
                    withAnimation(.interpolatingSpring(stiffness: 1000, damping: 5)) {
                        fontSize = 16.0
                    }
                }
        }
    }
}

struct CongratulationsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratulationsView()
    }
}
