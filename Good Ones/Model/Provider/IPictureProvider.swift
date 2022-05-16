//
//  IPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

protocol IPictureProvider {
    var pictures: [Picture] { get }
    
    func fetchAlbum()
}
