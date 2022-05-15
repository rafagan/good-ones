//
//  Picture.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation
import UIKit

struct Picture {
    let image: UIImage
    
    static func factoryFromLocal(fileName: String) -> Picture {
        Picture(image: UIImage(named: fileName)!)
    }
}
