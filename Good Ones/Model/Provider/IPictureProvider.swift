//
//  IPictureProvider.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

protocol IPictureProvider {
    func fetchAlbum(then: (() -> Void)?)
    func sync(then: @escaping () -> Void)
    func consume() -> [Picture]
}
