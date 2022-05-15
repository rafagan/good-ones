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
    
    let dragAreaThreshold: CGFloat = 130.0
    
    private func isTop(picture: Picture) -> Bool {
        guard let index = viewModel.pictures.firstIndex(where: { $0.id == picture.id }) else {
            return false
        }
        return index == 0
    }
    
    private func isFlippingLeft(_ translation: CGSize) -> Bool {
        translation.width < -self.dragAreaThreshold
    }
    
    private func isFlippingRight(_ translation: CGSize) -> Bool {
        translation.width > self.dragAreaThreshold
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(viewModel.pictures.reversed()) { picture in
                    let isTopCard = self.isTop(picture: picture)
                    
                    CardCellView(picture: picture)
                        .overlay(ZStack {
                            Image(systemName: "x.circle")
                                .modifier(SymbolModifier())
                                .opacity(
                                    (isFlippingLeft(dragState.translation) && isTopCard) ? 1.0 : 0.0
                                )
                            
                            Image(systemName: "heart.circle")
                                .modifier(SymbolModifier())
                                .opacity(
                                    (isFlippingRight(dragState.translation) && isTopCard) ? 1.0 : 0.0
                                )
                        })
                        .zIndex(isTopCard ? 1 : 0)
                        .offset(
                            x: isTopCard ? self.dragState.translation.width : 0,
                            y: isTopCard ? self.dragState.translation.height : 0)
                        .scaleEffect(self.dragState.isDragging && isTopCard ? 0.85 : 1.0)
                        .rotationEffect(
                            Angle(degrees: isTopCard
                                ? Double(self.dragState.translation.width / 12)
                                : 0)
                        )
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120), value: UUID())
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
                            .onEnded { value in
                                guard case .second(true, let drag?) = value else { return }
                                
                                if isFlippingLeft(drag.translation) {
                                    viewModel.onDismiss()
                                }
                                if isFlippingRight(drag.translation) {
                                    viewModel.onFavorite()
                                }
                            }
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
