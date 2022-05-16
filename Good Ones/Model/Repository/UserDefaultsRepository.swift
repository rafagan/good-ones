//
//  UserDefaultsRepository.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import Foundation

enum UserPhotoProvider: Int {
    case googlePhotos = 0
    case photoKit = 1
}

struct UserDefaultsRepository: IRepository {
    var isOnboardingDone: Bool {
        get {
            UserDefaults.standard.bool(forKey: "onboarding_done")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "onboarding_done")
            UserDefaults.standard.synchronize()
        }
    }
    
    var photoProvider: UserPhotoProvider {
        get {
            UserPhotoProvider.init(
                rawValue: UserDefaults.standard.integer(forKey: "user_photo_provider")
            ) ?? .photoKit
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "user_photo_provider")
            UserDefaults.standard.synchronize()
        }
    }
    
    func savePicture(_ picture: Picture) {
        UserDefaults.standard.setValue(picture.choice.rawValue, forKey: "picture_\(picture.id)")
        UserDefaults.standard.synchronize()
        print(pictureAlreadyBeenProcessed(id: picture.id))
    }
    
    func pictureAlreadyBeenProcessed(id: String) -> Bool {
        print("picture_\(id): \(UserDefaults.standard.object(forKey: "picture_\(id)") != nil)")
        return UserDefaults.standard.string(forKey: "picture_\(id)") != nil
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
