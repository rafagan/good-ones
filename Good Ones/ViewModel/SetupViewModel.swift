//
//  SetupViewModel.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import Foundation

class SetupViewModel: ObservableObject {
    let appState: AppState?
    var repository = UserDefaultsRepository()
    
    @Published var isStarting = false
    
    init(appState: AppState? = nil) {
        self.appState = appState
        
//        repository.resetDefaults()
    }
    
    func setupGooglePhotos() {
        appState?.scene = .main
        repository.photoProvider = .googlePhotos
        
        appState?.provider = GooglePhotoPictureProvider()
    }
    
    func setupPhotoKit() {
        isStarting = true
        repository.photoProvider = .photoKit
        
        CameraRollPictureProvider.askPermission { authorized in
            self.appState?.provider = authorized
                ? CameraRollPictureProvider(repository: self.repository)
                : LocalPictureProvider(repository: self.repository)
            
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                self?.appState?.provider?.fetchAlbum()
                
                self?.appState?.provider?.sync {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.appState?.scene = .main
                    }
                }
            }
        }
    }
}
