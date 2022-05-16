//
//  ContentView.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

struct CardCollectionView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: CardCollectionViewModel
    @GestureState private var dragState = DragState.inactive
    @State private var cardTransition: CardTransition? = nil
    
    let dragAreaThreshold: CGFloat = 130.0
    
    private func isTop(picture: Picture) -> Bool {
        guard let index = viewModel.pictures.firstIndex(where: { $0.id == picture.id }) else {
            return false
        }
        return index == 0
    }
    
    private func isFlippingLeft(_ translation: CGSize) -> Bool {
        translation.width < -dragAreaThreshold
    }
    
    private func isFlippingRight(_ translation: CGSize) -> Bool {
        translation.width > dragAreaThreshold
    }
    
    func animationOffset(picture: Picture) -> CGSize {
        if isTop(picture: picture) {
            if let t = cardTransition {
                let c = 1000
                
                switch t {
                case .leading:
                    return CGSize(width: -c, height: c)
                case .trailing:
                    return CGSize(width: c, height: c)
                }
            } else {
                let translation = dragState.translation
                return CGSize(width: translation.width, height: translation.height)
            }
        } else {
            return CGSize()
        }
    }
    
    func makeTransition(_ transition: CardTransition, then: @escaping () -> Void) {
        cardTransition = transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            cardTransition = nil
            then()
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(viewModel.visiblePictures) { picture in
                    let isTopCard = isTop(picture: picture)
                    
                    CardCellView(picture: picture, showDescription: isTopCard)
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
                        .offset(animationOffset(picture: picture))
                        .scaleEffect(dragState.isDragging && isTopCard ? 0.85 : 1.0)
                        .rotationEffect(
                            Angle(degrees: isTopCard
                                ? Double(dragState.translation.width / 12)
                                : 0)
                        )
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120), value: UUID())
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                            .updating($dragState, body: { (value, state, transaction) in
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
                                    viewModel.willDismiss()
                                    makeTransition(.leading) {
                                        viewModel.didDismiss()
                                    }
                                }
                                if isFlippingRight(drag.translation) {
                                    viewModel.willFavorite()
                                    makeTransition(.trailing) {
                                        viewModel.didFavorite()
                                    }
                                }
                            }
                        )
                }
            }
            .padding(.horizontal)
            .background(Color.black)
        }
    }
}

struct CardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardCollectionView(viewModel: CardCollectionViewModel())
    }
}
