//
//  FakeRepository.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

class FakeRepository: IRepository {
    var processedOnes = Set<String>()
    
    func savePicture(_ picture: Picture) {
        print("Picture \(picture.id) saved")
        processedOnes.insert(picture.id)
    }
    
    func pictureAlreadyBeenProcessed(id: String) -> Bool {
        processedOnes.contains(id)
    }
}
