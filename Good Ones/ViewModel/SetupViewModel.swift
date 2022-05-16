//
//  SetupViewModel.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import Foundation
import GPhotos

class SetupViewModel: ObservableObject {
    let appState: AppState?
    var repository = UserDefaultsRepository()
    
    @Published var isStarting = false
    
    init(appState: AppState? = nil) {
        self.appState = appState
        
//        repository.resetDefaults()
    }
    
    func setupGooglePhotos() {
        isStarting = true
        repository.photoProvider = .googlePhotos
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            GPhotos.authorize()
            
            guard let self = self else { return }
            
            self.appState?.provider = GPhotos.isAuthorized
                ? GooglePhotoPictureProvider(repository: self.repository)
                : LocalPictureProvider(repository: self.repository)
         
            self.appState?.provider?.fetchAlbum {
                self.routeToMain()
            }
        }
    }
    
    func setupPhotoKit() {
        isStarting = true
        repository.photoProvider = .photoKit
        
        CameraRollPictureProvider.askPermission { authorized in
            self.appState?.provider = authorized
                ? CameraRollPictureProvider(repository: self.repository)
                : LocalPictureProvider(repository: self.repository)
            
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                self?.appState?.provider?.fetchAlbum {
                    self?.routeToMain()
                }
            }
        }
    }
    
    func routeToMain() {
        DispatchQueue.main.async { [weak self] in
            self?.appState?.provider?.sync {
                self?.appState?.scene = .main
            }
        }
    }
}
