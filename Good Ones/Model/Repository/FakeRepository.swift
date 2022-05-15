//
//  FakeRepository.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

struct FakeRepository: IRepository {
    var processedOnes = Set<UUID>()
    
    mutating func savePicture(_ picture: Picture) {
        print("Picture \(picture.id) saved")
        processedOnes.insert(picture.id)
    }
    
    func pictureAlreadyBeenProcessed(_ picture: Picture) -> Bool {
        processedOnes.contains(picture.id)
    }
}
