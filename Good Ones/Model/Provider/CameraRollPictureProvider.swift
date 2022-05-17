//
//  CameraRollPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation
import Photos
import UIKit


class CameraRollPictureProvider: IPictureProvider {
    static let useAllPhotos = true
    static let resolution = CGSize(width: 3264, height: 2448)
    static let previewResolution = CGSize(width: 3264 / 10, height: 2448 / 10)
    
    static func askPermission(then: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            then(true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            then(status == .authorized)
        }
    }
    
    static func factoryPicture(asset: PHAsset, image: UIImage?) -> Picture {
        Picture(
            id: asset.localIdentifier,
            image: image,
            title: asset.creationDate?.getFormattedDate(style: .short) ?? "",
            subtitle: asset.creationDate?.getFormattedDate(style: .full) ?? "",
            choice: .unknown,
            date: asset.creationDate
        )
    }
    
    static func fetchAsset(_ asset: PHAsset, in picture: Picture?) {
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        
        for op in [
            (PHImageRequestOptionsDeliveryMode.fastFormat, self.previewResolution),
            (.highQualityFormat, self.resolution)
        ] {
            options.deliveryMode = op.0
            fetchImage(asset, targetSize: op.1, options: options) {
                guard var img = $0 else { return }
                
                if img.size.width > img.size.height {
                    img = img.rotated ?? img
                }
                
                picture?.image = img
            }
        }
    }
    
    static func fetchImage(
        _ asset: PHAsset?,
        targetSize size: CGSize,
        contentMode: PHImageContentMode = .aspectFill,
        options: PHImageRequestOptions? = nil,
        then: ((UIImage?) -> Void)?
    ) {
        guard let asset = asset else {
            then?(nil)
            return
        }
        
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            then?(image)
        }
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: contentMode,
            options: options,
            resultHandler: resultHandler
        )
    }
    
    static func fetchFavoriteAssets(collect: @escaping (Data?, Date?) -> Void) {
        PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .albumRegular,
            options: nil
        ).enumerateObjects({collection, idx, stop in
            guard collection.localizedTitle == "Favorites" else { return }
            
            let options = PHImageRequestOptions()
            options.version = .current
            options.resizeMode = .exact
            options.isNetworkAccessAllowed = true
            options.isSynchronous = false
            options.deliveryMode = .highQualityFormat

            PHAsset.fetchAssets(
                in: collection,
                options: nil
            ).enumerateObjects({ asset, idx, stop in
                let date = asset.creationDate
                
                fetchImage(asset, targetSize: self.resolution, options: options) { image in
                    collect(image?.data, date)
                }
            })
        })
    }
    
    private var assets = [PHAsset]()
    private var lastIndex = 0
    private let repository: IRepository
    
    var cachedPictures = [Picture]()
    
    init(repository: IRepository) {
        self.repository = repository
    }
    
    func fetchAlbum(then: (() -> Void)? = nil) {
        let enumerateAssetsCallback: (PHAsset, Int, UnsafeMutablePointer<ObjCBool>) -> Void = { asset, idx, stop in
            if self.repository.pictureAlreadyBeenProcessed(id: asset.localIdentifier) { return }
            self.assets.append(asset)
        }
        
        if CameraRollPictureProvider.useAllPhotos {
            let options = PHFetchOptions()
            options.sortDescriptors = [
                NSSortDescriptor(
                    key: "creationDate",
                    ascending: false
                )
            ]
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            PHAsset.fetchAssets(
                with: options
            ).enumerateObjects(enumerateAssetsCallback)
            then?()
        } else {
            PHAssetCollection.fetchAssetCollections(
                with: .album,
                subtype: .albumRegular,
                options: nil
            ).enumerateObjects({collection, idx, stop in
                guard collection.localizedTitle == "Test" else { return }
                
                PHAsset.fetchAssets(
                    in: collection,
                    options: nil
                ).enumerateObjects(enumerateAssetsCallback)
                then?()
            })
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
                Self.fetchAsset(asset, in: weakPicture)
                self.lastIndex += 1
            }

            DispatchQueue.main.async {
                then()
            }
        }
    }
    
    func consume() -> [Picture] {
        let pics = cachedPictures
        cachedPictures = [Picture]()
        return pics
    }
}
