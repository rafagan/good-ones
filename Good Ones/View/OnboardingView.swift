//
//  OnboardingView.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 15/05/22.
//

import SwiftUI

struct OnboardingCellView: View {
    let systemImageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.teal)
            
            Text(title)
                .font(.title).bold()
            
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 40)
    }
}

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    func finishOnboarding() {
        withAnimation {
            viewModel.finishOnboarding()
        }
    }
    
    var body: some View {
        VStack {
            TabView {
                OnboardingCellView(
                    systemImageName: "arrowshape.zigzag.forward",
                    title: "The Good Ones",
                    description: "Swipe to pick the photos you like and dismiss the ones you don't prefer"
                )
                
                OnboardingCellView(
                    systemImageName: "heart.circle",
                    title: "Your favorites",
                    description: "Swipe right to favorite, and left to dismiss. Simple!"
                )
                
                OnboardingCellView(
                    systemImageName: "checkmark.icloud.fill",
                    title: "Cloud friendly",
                    description: "Login with your Google Photos account and organize hundreds of photos faster"
                )
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Button(action: finishOnboarding) {
                Text("Let's start!")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .accentColor(Color.pink)
                    .background(
                        Capsule().stroke(Color.pink, lineWidth: 2)
                    )
            }
            .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel())
    }
}
