//
//  OnboardingViewModel.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    var repository = UserDefaultsRepository()
    let appState: AppState?
    
    init(appState: AppState? = nil) {
        self.appState = appState
    }
    
    func finishOnboarding() {
        repository.isOnboardingDone = true
        appState?.scene = .setup
    }
}
