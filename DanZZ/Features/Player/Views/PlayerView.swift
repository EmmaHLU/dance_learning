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
    @StateObject var viewModel: PlayerViewModel
    @EnvironmentObject var localeManager: LocalManager
    
    init(localeManager: LocalManager) {
        _viewModel = StateObject(wrappedValue: PlayerViewModel(locale: localeManager.currentLocale))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isVideoLoaded, let player = viewModel.player{
                VideoPlayer(player: player).frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Color.black.overlay(
                    VStack {
                        Text ("player.aiPlayer").font(.largeTitle).foregroundColor(.white)
//                        Text("Tap the button to load a dance video").foregroundColor(.gray)
                    }
                )
            }
            VStack {
                Spacer()
                ZStack(alignment: .bottom){
                    HStack {
                        
                        //select file to open button
                        Button (action: viewModel.openFilePicker){
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding(.leading, 20)
                        Spacer()
                        //microphone button
                        Button(action: {
                            if viewModel.isRecording{
                                viewModel.stopSpeech()
                            }else {
                                viewModel.player?.pause()
                                viewModel.startSpeech()
                            }
                            
                        }) {
                            Image(systemName: viewModel.isRecording ? "mic.slash.fill" : "mic.fill")
                                             .font(.system(size: 20))
                                             .foregroundColor(.white)
                                             .padding()
                                             .background(viewModel.isRecording ? Color.red : Color.blue)
                                             .clipShape(Circle())
                        }
                        .padding(.trailing, 30)
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
                    Task {
                            viewModel.extractBeats(url: url)
                            await viewModel.loadVideo(url: url)
                            
                        }
                }
            }
        }
        
        }
}
