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
    let defaultPhotoResolution = CGSize(width: 3264, height: 2448)
    
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
            PHAsset.fetchAssets(
                with: allPhotosOptions
            ).enumerateObjects({asset, idx, stop in
                self.fetchAsset(asset)
            })
        } else {
            PHAssetCollection.fetchAssetCollections(
                with: .album,
                subtype: .albumRegular,
                options: nil
            ).enumerateObjects({collection, idx, stop in
                if collection.localizedTitle == "Test" {
                    PHAsset.fetchAssets(
                        in: collection,
                        options: nil
                    ).enumerateObjects({asset, idx, stop in
                        self.fetchAsset(asset)
                    })
                }
            })
        }
    }
    
    
    func fetchAsset(_ asset: PHAsset) {
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .fast
        options.deliveryMode = .highQualityFormat // TODO: Use opportunistic
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        
        self.fetchImage(asset, targetSize: self.defaultPhotoResolution, options: options) {
            guard let img = $0 else { return }
            self.pictures.append(Picture(
                id: asset.localIdentifier,
                image: img,
                title: asset.creationDate?.getFormattedDate(style: .short) ?? "",
                subtitle: asset.creationDate?.getFormattedDate(style: .full) ?? "",
                choice: .unknown
            ))
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
