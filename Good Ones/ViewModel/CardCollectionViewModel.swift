//
//  CardCollectionViewModel.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

class CardCollectionViewModel: ObservableObject {
    let appState: AppState?
    var provider: IPictureProvider!
    var repository = FakeRepository()
    var currentPictureIndex = 0
    let photoCacheSize = 10
    
    @Published var pictures = [Picture]()
    @Published var isStarting = false
    @Published var isLoading = false
    
    var foregroundPicture: Picture? {
        currentPictureIndex < pictures.count ? pictures[currentPictureIndex] : nil
    }
    
    var backgroundPicture: Picture? {
        currentPictureIndex + 1 < pictures.count ? pictures[currentPictureIndex + 1] : nil
    }
    
    var haveStarvedPictures: Bool {
        foregroundPicture == nil && backgroundPicture == nil
    }
    
    var visiblePictures: [Picture] {
        var ps = [Picture]()
        if let p = foregroundPicture { ps.append(p) }
        if let p = backgroundPicture { ps.append(p) }
        return ps
    }
    
    init(appState: AppState?) {
        self.appState = appState
        fetchPhotos()
        
        UserDefaults.resetStandardUserDefaults()
    }
    
    // TODO: Primeira foto nao aparece
    // TODO: Identificar se foto é landscape
    // TODO: Verificar persistencias
    
    func fetchPhotos() {
        isStarting = true
        
        CameraRollPictureProvider.askPermission { authorized in
            self.provider = authorized
                ? CameraRollPictureProvider(repository: self.repository, photoCacheSize: self.photoCacheSize)
                : LocalPictureProvider(repository: self.repository)
            
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                self?.provider.fetchAlbum()
                
                DispatchQueue.main.async {
                    self?.isStarting = false
                    self?.synchronize()
                }
            }
        }
    }
    
    func synchronize() {
        provider.sync { [weak self] in
            guard let self = self else { return }
            
            if self.pictures.count < self.photoCacheSize / 2 {
                self.pictures.append(contentsOf: self.provider.consume())
            }
            
            if self.pictures.isEmpty {
                self.didFinish()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.synchronize()
            }
        }
    }
    
    func willDismiss() {
        playDismiss()
        haptic()
    }
    
    func didDismiss() {
        guard let pic = foregroundPicture else { return }
        pic.choice = .dismissed
        repository.savePicture(pic)
        pictures.removeFirst()
        
        if pictures.isEmpty {
            didFinish()
        }
    }
    
    func willFavorite() {
        playFavorite()
        haptic()
    }
    
    func didFavorite() {
        guard let pic = foregroundPicture else { return }
        pic.choice = .favorited
        repository.savePicture(pic)
        pictures.removeFirst()
        
        if pictures.isEmpty {
            didFinish()
        }
    }
    
    func didFinish() {
        playContratulations()
        vibrate()
        appState?.scene = .congrats
    }
}
