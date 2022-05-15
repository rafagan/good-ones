//
//  Picture.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation
import UIKit

enum PictureChoice: String {
    case favorited = "favorited"
    case dismissed = "dismissed"
    case unknown = "unknown"
}

struct Picture: Identifiable {
    let id = UUID()
    let image: UIImage
    let title: String
    let subtitle: String
    var choice: PictureChoice
    
    static func factoryFromLocal(fileName: String) -> Picture {
        Picture(
            image: UIImage(named: fileName)!,
            title: fileName,
            subtitle: "1970-01-01",
            choice: .unknown
        )
    }
}
