//
//  LocalPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import UIKit

struct LocalPictureProvider: IPictureProvider {
    static func factoryPicture(fileName: String) -> Picture {
        return Picture(
            id: UUID().uuidString,
            image: UIImage(named: fileName)!,
            title: fileName,
            subtitle: "1970-01-01",
            choice: .unknown
        )
    }
    
    var pictures: [Picture] {
        [
            LocalPictureProvider.factoryPicture(fileName: "Cat1"),
            LocalPictureProvider.factoryPicture(fileName: "Cat2"),
            LocalPictureProvider.factoryPicture(fileName: "Cat3"),
            LocalPictureProvider.factoryPicture(fileName: "Cat4"),
            LocalPictureProvider.factoryPicture(fileName: "Cat5")
        ]
    }
    
    func fetchAlbum() {
        
    }
}
