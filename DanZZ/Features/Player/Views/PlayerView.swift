//
//  PlayerView.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation
import AVKit
import SwiftUI

//page for the player
struct PlayerView: View {
    @StateObject var viewModel = PlayerViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isVideoLoaded, let player = viewModel.player{
                VideoPlayer(player: player).frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Color.black.overlay(
                    VStack {
                        Text ("Your Dance AI Player").font(.largeTitle).foregroundColor(.white)
                        Text("Tap the button to load a dance video").foregroundColor(.gray)
                    }
                )
            }
            VStack {
                Spacer()
                ZStack(alignment: .bottom){
                    HStack {
                        Spacer()
                        //select file to open button
                        Button (action: viewModel.openFilePicker){
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                    }
                    //microphone button
                    Button(action: {
                        print("Microphone button tapped")
                    }) {
                        Image(systemName: "mic.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                    }
                }
                
                .padding(.bottom, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $viewModel.showingFilePicker){
            PhotoVideoPicker(isPresented: $viewModel.showingFilePicker){
                url in
                if let url = url {
                    viewModel.loadVideo(url: url)
                }
            }
        }
        
        }
}
