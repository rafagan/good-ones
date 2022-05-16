//
//  CameraRollPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation
import Photos
import UIKit


enum AlbumCollectionSectionType: Int, CustomStringConvertible {
    case all, smartAlbums, userCollections

    var description: String {
        switch self {
            case .all: return "All Photos"
            case .smartAlbums: return "Smart Albums"
            case .userCollections: return "User Collections"
        }
    }
}


class CameraRollPictureProvider: IPictureProvider {
    static let useAllPhotos = false
    
    static func askPermission(then: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            then(true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            then(status == .authorized)
        }
    }
    
    var pictures = [Picture]()
    
    func fetchAlbum() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false
            )
        ]
        
        if CameraRollPictureProvider.useAllPhotos {
            let allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
            
            allPhotos.enumerateObjects({asset, idx, stop in
                self.fetchImage(asset, targetSize: CGSize(width: 100, height: 100)) {
                    guard let img = $0 else { return }
                    self.pictures.append(Picture(
                        image: img,
                        title: asset.localIdentifier,
                        subtitle: asset.creationDate?.description ?? "?",
                        choice: .unknown
                    ))
                }
            })
        }
        
        PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil
        ).enumerateObjects({collection, idx, stop in
            if collection.localizedTitle == "Test" {
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                assets.enumerateObjects({asset, idx, stop in
                    self.fetchImage(asset, targetSize: CGSize(width: 100, height: 100)) {
                        guard let img = $0 else { return }
                        self.pictures.append(Picture(
                            image: img,
                            title: asset.localIdentifier,
                            subtitle: asset.creationDate?.description ?? "?",
                            choice: .unknown
                        ))
                    }
                })
            }
        })
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
