//
//  ContentView.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

struct CardCollectionView: View {
    @ObservedObject var viewModel: CardCollectionViewModel
    
    var body: some View {
        Image(uiImage: viewModel.pictures.first!.image)
            .padding()
    }
}

struct CardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardCollectionView(viewModel: CardCollectionViewModel())
    }
}
