//
//  MainView.swift
//  DanZZ
//
//  Created by Hong Lu on 03/12/2025.
//

import Foundation
import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var localeManager: LocalManager
    var body: some View {
        TabView {
            NavigationStack {
                PlayerView(localeManager: localeManager)
                    .navigationTitle("DanZZ Player")
            }
            .tabItem {
                Label("play", systemImage: "music.note")
            }
            .tag(1)
            
            
            NavigationStack {
                ProfileView(localeManager: localeManager)
                    .navigationTitle("My Profile")
            }
            .tabItem {
                Label("Mine", systemImage: "person.crop.circle")
            }
            .tag(2)
        }
    }
}
