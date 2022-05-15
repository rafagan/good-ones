//
//  LocalPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

struct LocalPictureProvider: IPictureProvider {
    var pictures: [Picture] {
        [
            Picture.factoryFromLocal(fileName: "Cat1"),
            Picture.factoryFromLocal(fileName: "Cat2"),
            Picture.factoryFromLocal(fileName: "Cat3"),
            Picture.factoryFromLocal(fileName: "Cat4"),
            Picture.factoryFromLocal(fileName: "Cat5")
        ]
    }
}
