//
//  CardCollectionViewModel.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import Foundation

class CardCollectionViewModel: ObservableObject {
    let provider = LocalPictureProvider()
    @Published var pictures = [Picture]()
    
    init() {
        self.pictures = provider.pictures
    }
}
