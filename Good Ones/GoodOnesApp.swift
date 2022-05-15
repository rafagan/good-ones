//
//  Good_OnesApp.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

@main
struct GoodOnesApp: App {
    var body: some Scene {
        WindowGroup {
            CardCollectionView(viewModel: CardCollectionViewModel())
        }
    }
}
