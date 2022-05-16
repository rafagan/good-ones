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
    static let useAllPhotos = false
    let resolution = CGSize(width: 3264, height: 2448)
    let previewResolution = CGSize(width: 3264 / 10, height: 2448 / 10)
    let photoCacheSize: Int
    
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
            id: asset.creationDate!.description,
            image: image,
            title: asset.creationDate?.getFormattedDate(style: .short) ?? "",
            subtitle: asset.creationDate?.getFormattedDate(style: .full) ?? "",
            choice: .unknown
        )
    }
    
    private var assets = [PHAsset]()
    private var lastIndex = 0
    private let repository: IRepository
    
    var cachedPictures = [Picture]()
    
    init(repository: IRepository, photoCacheSize: Int) {
        self.repository = repository
        self.photoCacheSize = photoCacheSize
    }
    
    func fetchAlbum() {
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
            PHAsset.fetchAssets(with: options)
                .enumerateObjects(enumerateAssetsCallback)
        } else {
            PHAssetCollection.fetchAssetCollections(
                with: .album,
                subtype: .albumRegular,
                options: nil
            ).enumerateObjects({collection, idx, stop in
                guard collection.localizedTitle == "Test" else { return }
                
                PHAsset.fetchAssets(in: collection, options: nil)
                    .enumerateObjects(enumerateAssetsCallback)
            })
        }
    }
    
    func sync(then: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let amountToLoad = self.photoCacheSize - self.cachedPictures.count
            for _ in 0..<amountToLoad {
                if self.lastIndex >= self.assets.count{
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
    
    func consume() -> [Picture] {
        let pics = cachedPictures
        cachedPictures = [Picture]()
        print("consumed \(cachedPictures.count)")
        return pics
    }
    
    
    func fetchAsset(_ asset: PHAsset, in picture: Picture?) {
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        options.deliveryMode = .fastFormat
        self.fetchImage(asset, targetSize: self.previewResolution, options: options) {
            guard let img = $0 else { return }
            picture?.image = img
        }
        
        options.deliveryMode = .highQualityFormat
        self.fetchImage(asset, targetSize: self.resolution, options: options) {
            guard let img = $0 else { return }
            picture?.image = img
        }
    }
    
    func fetchImage(
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
}
