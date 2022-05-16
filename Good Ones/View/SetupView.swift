//
//  SetupView.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import SwiftUI

struct SetupView: View {
    @ObservedObject var viewModel: SetupViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 50) {
                Spacer(minLength: 40)
                
                Text("Good Ones")
                    .fontWeight(.black)
                    .font(.largeTitle)
                    .foregroundColor(.pink)
                
                Spacer(minLength: 40)
                
                Text("Discover and pick the best photos from your gallery!")
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                
                Text("From which provider would you like to play?")
                    .multilineTextAlignment(.center)
                
                Spacer(minLength: 30)
                
                HStack {
                    Button(action: { viewModel.setupPhotoKit() }) {
                        Text("Camera Roll")
                            .font(.headline)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Capsule().fill(.pink))
                            .foregroundColor(.white)
                    }.disabled(viewModel.isStarting)
                    Button(action: { viewModel.setupGooglePhotos() }) {
                        Text("Google Photos")
                            .font(.headline)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Capsule().fill(.pink))
                            .foregroundColor(.white)
                    }.disabled(viewModel.isStarting)
                }
                if viewModel.isStarting {
                    ProgressView()
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, 15)
            .padding(.bottom, 25)
            .padding(.horizontal, 25)
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView(viewModel: SetupViewModel())
    }
}
