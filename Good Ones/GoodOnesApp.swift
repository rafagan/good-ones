//
//  Good_OnesApp.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

enum SceneType {
    case main
    case onboarding
    case congrats
}

class AppState: ObservableObject {
    @Published var scene: SceneType

    init(scene: SceneType) {
        self.scene = scene
    }
}

@main
struct GoodOnesApp: App {
    @ObservedObject var appState = AppState(scene: .main)
    
    var body: some Scene {
        WindowGroup {
            switch appState.scene {
            case .main:
                CardCollectionView(viewModel: CardCollectionViewModel(appState: appState))
                    .environmentObject(appState)
            case .congrats:
                CongratulationsView()
                    .environmentObject(appState)
            case .onboarding:
                OnboardingView()
                    .environmentObject(appState)
            }
        }
    }
}

