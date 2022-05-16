//
//  IRepository.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

protocol IRepository {
    func savePicture(_ picture: Picture)
    func pictureAlreadyBeenProcessed(id: String) -> Bool
}
