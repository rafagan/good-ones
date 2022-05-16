//
//  LocalPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import UIKit

class LocalPictureProvider: IPictureProvider {
    static func factoryPicture(fileName: String) -> Picture {
        return Picture(
            id: UUID().uuidString,
            image: UIImage(named: fileName)!,
            title: fileName,
            subtitle: "1970-01-01",
            choice: .unknown
        )
    }
    
    var cachedPictures = [
        LocalPictureProvider.factoryPicture(fileName: "Cat1"),
        LocalPictureProvider.factoryPicture(fileName: "Cat2"),
        LocalPictureProvider.factoryPicture(fileName: "Cat3"),
        LocalPictureProvider.factoryPicture(fileName: "Cat4"),
        LocalPictureProvider.factoryPicture(fileName: "Cat5")
    ]
    
    private let repository: IRepository
    
    init(repository: IRepository) {
        self.repository = repository
    }
    
    func fetchAlbum(then: (() -> Void)? = nil) {
    }
    
    func sync(then: @escaping () -> Void) {
        cachedPictures = cachedPictures.filter({ !repository.pictureAlreadyBeenProcessed(id: $0.id) })
        then()
    }
    
    func consume() -> [Picture] {
        let pics = cachedPictures
        cachedPictures = [Picture]()
        return pics
    }
}
