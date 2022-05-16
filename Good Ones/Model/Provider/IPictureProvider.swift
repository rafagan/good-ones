//
//  IPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

protocol IPictureProvider {
    func fetchAlbum()
    func sync(then: @escaping () -> Void)
    func consume() -> [Picture]
}
