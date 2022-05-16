//
//  GooglePhotoPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation
import GPhotos

class GooglePhotoPictureProvider: IPictureProvider {
    static func factoryPicture(asset: MediaItem, image: UIImage?) -> Picture {
        return Picture(
            id: asset.id,
            image: image,
            title: asset.mediaMetadata?.creationTime?.getFormattedDate(style: .short) ?? "",
            subtitle: asset.filename,
            choice: .unknown
        )
    }
    
    private var assets = [MediaItem]()
    private let repository: IRepository
    
    private var lastIndex = 0
    
    var cachedPictures = [Picture]()
    
    init(repository: IRepository) {
        self.repository = repository
    }
    
    func fetchAlbum(then: (() -> Void)? = nil) {
        GPhotosApi.mediaItems.list {[weak self] items in
            self?.assets = items
            then?()
        }
    }
    
    
    func sync(then: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let amountToLoad = photoCacheSize - self.cachedPictures.count
            for _ in 0..<amountToLoad {
                if self.lastIndex >= self.assets.count {
                    break
                }
                
                let asset = self.assets[self.lastIndex]
                let picture = Self.factoryPicture(asset: asset, image: nil)
                self.cachedPictures.append(picture)
                
                weak var weakPicture = picture
                self.fetchAsset(asset, in: weakPicture)
                self.lastIndex += 1
            }

            DispatchQueue.main.async {
                then()
            }
        }
    }
    
    func fetchAsset(_ asset: MediaItem, in picture: Picture?) {
        guard let url = asset.baseUrl else { return }
        
        var image = UIImage.factoryFrom(url: url)
        
        if let img = image {
            if img.size.width > img.size.height {
                image = image?.rotated
            }
        }
        
        picture?.image = image
    }
    
    func consume() -> [Picture] {
        let pics = cachedPictures
        cachedPictures = [Picture]()
        return pics
    }
}
