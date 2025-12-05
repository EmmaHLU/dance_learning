//
//  AuthCheckView.swift
//  DanZZ
//
//  Created by Hong Lu on 05/12/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct AuthCheckView: View {
    @StateObject var viewModel = AuthCheckViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated == true {
                MainContentView()
            } else if viewModel.isAuthenticated == false {
                NavigationView{
                    SignInView()
                }
            }else {
                ProgressView()
                    .onAppear(){
                        viewModel.setupAuthStateListener()
                    }
            }
        }
    }
    
}
