//
//  CardCollectionViewModel.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation


class CardCollectionViewModel: ObservableObject {
    let appState: AppState?
    let enablePerceptualHash = false
    var imageSaver: ImageSaver?
    var repository = UserDefaultsRepository()
    var currentPictureIndex = 0
    
    @Published var pictures = [Picture]()
    
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
    
    init(appState: AppState? = nil) {
        self.appState = appState
        synchronize()
        initImageSaver()
    }
    
    func initImageSaver() {
        if repository.photoProvider != .googlePhotos { return }
        
        imageSaver = ImageSaver()
        CameraRollPictureProvider.fetchFavoriteAssets(collect: {[weak self] data, date in
            guard let self = self else { return }
            
            if let data = data, self.enablePerceptualHash {
                self.imageSaver?.templates.append(.perceptualHash(data))
            } else
            if let date = date {
                self.imageSaver?.templates.append(.naive(date))
            }
        })
    }
    
    func synchronize() {
        guard let provider = appState?.provider else { return }
        
        provider.sync { [weak self] in
            guard let self = self else { return }
            
            if self.pictures.count < photoCacheSize / 2 {
                self.pictures.append(contentsOf: provider.consume())
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
        runAction(.dismissed)
    }
    
    func willFavorite() {
        playFavorite()
        haptic()
    }
    
    func didFavorite() {
        if repository.photoProvider == .googlePhotos {
            if let picture = foregroundPicture {
                imageSaver?.savePhotoIfNotExists(picture: picture)
            }
        }
        
        runAction(.favorited)
    }
    
    func runAction(_ action: PictureChoice) {
        guard let pic = foregroundPicture else { return }
        pic.choice = action
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
