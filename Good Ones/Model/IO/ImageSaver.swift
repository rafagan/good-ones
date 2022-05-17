//
//  IO.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import UIKit
import Photos
import CocoaImageHashing

enum ImageComparisonStrategy {
    case naive(Date)
    case perceptualHash(Data)
}

class ImageSaver: NSObject {
    var date: Date?
    var templates = [ImageComparisonStrategy]()
    
    func savePhoto(_ image: UIImage, date: Date? = nil) {
        if let date = date {
            self.date = date
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), &self.date)
        } else {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), &self.date)
        }
    }
    
    @objc func saveCompleted(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        let date = contextInfo.assumingMemoryBound(to: Date?.self).pointee
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

        if let asset = fetchResult.lastObject {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest(for: asset)
                request.isFavorite = true
                request.creationDate = date
            }, completionHandler: { success, error in
                print("Image saved and added to favorites")
            })
        }
    }

    func savePhotoIfNotExists(picture: Picture) {
        guard let img = picture.image else { return }
        guard let date = picture.date else { return }
        guard let data = img.data else { return }
        let instance = OSImageHashing.sharedInstance()
        
        if templates.contains(where: {
            switch $0 {
            case .naive(let d):
                return date == d
            case .perceptualHash(let d):
                return instance.compareImageData(data, to: d, with: .pHash)
            }
        }) {
            print("Element exists in favorites library")
            return
        }
        
        savePhoto(img, date: picture.date)
    }
}
