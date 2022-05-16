//
//  CardView.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

enum CardTransition {
    case leading
    case trailing
}

struct CardCellView: View {
    var picture: Picture
    var showDescription: Bool
    
    var body: some View {
        VStack {
            if let img = picture.image {
                Image(uiImage: img)
                    .resizable()
                    .cornerRadius(24)
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity)
            }

            
            if showDescription {
                VStack(alignment: .center, spacing: 12) {
                    Text(picture.title.uppercased())
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .shadow(radius: 5)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                        .overlay(
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 1),
                            alignment: .bottom
                        )
                    Text(picture.subtitle.uppercased())
                        .foregroundColor(Color.black)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .frame(minWidth: 85)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.white)
                        )
                }
                .padding(.bottom, 50)
                .shadow(radius: 10)
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardCellView(picture: LocalPictureProvider(repository: FakeRepository()).cachedPictures[3], showDescription: true)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
    }
}
