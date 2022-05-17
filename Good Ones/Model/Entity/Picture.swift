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

class Picture: Identifiable {
    let id: String
    var image: UIImage?
    let title: String
    let subtitle: String
    var choice: PictureChoice
    var date: Date?
    
    init(id: String, image: UIImage?, title: String, subtitle: String, choice: PictureChoice, date: Date?) {
        self.id = id
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.choice = choice
        self.date = date
    }
}
