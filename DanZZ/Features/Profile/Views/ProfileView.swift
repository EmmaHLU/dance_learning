//
//  ProfileView.swift
//  DanZZ
//
//  Created by Hong Lu on 03/12/2025.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var localeManager: LocalManager
    @StateObject private var viewModel: ProfileViewModel
    
    init (localeManager: LocalManager) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(localeManger: localeManager))
    }
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text(viewModel.name ?? "profile.name")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding(.bottom, 20)
                
                Text(viewModel.email ?? "N/A")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
            .padding(.vertical, 30)
                        
            List {
                Picker("language.select", selection: $viewModel.selectedLanguageCode) {
                    ForEach(LocalManager.availableLanguages){lang in
                        Text(lang.name)
                            .tag(lang.code)
                    }
                }
                .onChange(of: viewModel.selectedLanguageCode){
                    viewModel.setLanguage()
                }
                Button(action: {
                    viewModel.signOut()
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.red)
                        Text("profile.logout")
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(.insetGrouped) // Provides a clean, sectioned look
            
            Spacer()
        }
        .padding(.vertical, 30)
    }
}
