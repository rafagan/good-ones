//
//  CardCollectionViewModel.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

class CardCollectionViewModel: ObservableObject {
    let provider = LocalPictureProvider()
    var repository = FakeRepository()
    @Published var pictures = [Picture]()
    var currentPictureIndex = 0
    
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
    
    init() {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        pictures = provider.pictures.filter({
            !repository.pictureAlreadyBeenProcessed($0)
        })
    }
    
    func onDismiss() {
        guard var pic = foregroundPicture else { return }
        pic.choice = .dismissed
        repository.savePicture(pic)
        pictures.removeFirst()
    }
    
    func onFavorite() {
        guard var pic = foregroundPicture else { return }
        pic.choice = .favorited
        repository.savePicture(pic)
        pictures.removeFirst()
    }
}
