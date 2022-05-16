//
//  IO.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import UIKit
import Photos

class ImageSaver: NSObject {
    func savePhoto(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

        if let asset = fetchResult.lastObject {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest(for: asset)
                request.isFavorite = true
            }, completionHandler: { success, error in
                print("Image saved and added to favorites")
            })
        }
    }

    func savePhotoIfNotExistsNaive(image: UIImage) {
        savePhoto(image)
    }

    func savePhotoIfNotExists(image: UIImage) {
        savePhoto(image)
    }
}
