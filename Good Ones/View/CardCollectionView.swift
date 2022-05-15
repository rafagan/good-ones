//
//  ContentView.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

struct CardCollectionView: View {
    @ObservedObject var viewModel: CardCollectionViewModel
    @GestureState private var dragState = DragState.inactive
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(viewModel.pictures) { picture in CardCellView(picture: picture)
                    .zIndex(1)
                    .offset(x: self.dragState.translation.width, y: self.dragState.translation.height)
                    .scaleEffect(self.dragState.isDragging ? 0.85 : 1.0)
                    .rotationEffect(Angle(degrees: Double(self.dragState.translation.width / 12)))
                    .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                    .gesture(LongPressGesture(minimumDuration: 0.01)
                        .sequenced(before: DragGesture())
                        .updating(self.$dragState, body: { (value, state, transaction) in
                            switch value {
                            case .first(true):
                                state = .pressing
                            case .second(true, let drag):
                                state = .dragging(translation: drag?.translation ?? .zero)
                            default:
                                break
                            }
                        })
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardCollectionView(viewModel: CardCollectionViewModel())
    }
}
