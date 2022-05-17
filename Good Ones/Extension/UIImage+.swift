//
//  UIImage+.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import Foundation
import UIKit

extension UIImage {
    static func factoryFrom(url: URL) -> UIImage? {
        guard let date = NSData(contentsOf: url) as? Data else { return nil }
        return UIImage(data: date)
    }
    
    var rotated: UIImage? {
        guard let cg = cgImage else { return nil }
        return UIImage(cgImage: cg, scale: scale, orientation: .right)
    }
    
    var data: Data? {
        return cgImage?.dataProvider?.data as Data?
    }
}
