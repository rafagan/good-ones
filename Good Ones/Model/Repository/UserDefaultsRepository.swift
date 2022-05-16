//
//  UserDefaultsRepository.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import Foundation

struct UserDefaultsRepository: IRepository {
    func savePicture(_ picture: Picture) {
        UserDefaults.standard.set(picture.choice.rawValue, forKey: "picture_\(picture.id)")
    }
    
    func pictureAlreadyBeenProcessed(id: String) -> Bool {
        return UserDefaults.standard.object(forKey: "picture_\(id)") != nil
    }
}
