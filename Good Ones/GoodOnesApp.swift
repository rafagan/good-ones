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
    case setup
}

class AppState: ObservableObject {
    @Published var scene: SceneType
    var provider: IPictureProvider?

    init(scene: SceneType) {
        self.scene = scene
    }
}

@main
struct GoodOnesApp: App {
    let repository = UserDefaultsRepository()
    @ObservedObject var appState: AppState
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        self.appState = AppState(scene: repository.isOnboardingDone ? .setup : .onboarding)
    }
    
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
                OnboardingView(viewModel: OnboardingViewModel(appState: appState))
                    .environmentObject(appState)
            case .setup:
                SetupView(viewModel: SetupViewModel(appState: appState))
                    .environmentObject(appState)
            }
        }
    }
}

