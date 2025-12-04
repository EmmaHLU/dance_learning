//
//  SignInView.swift
//  DanZZ
//
//  Created by Hong Lu on 03/12/2025.
//

import Foundation
import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SingInViewModel()
    
    var body: some View {
        VStack {
            Text("text.signin")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 30)
            
            VStack {
                TextField("profile.email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .foregroundStyle(.secondary)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                SecureField("signin.password", text: $viewModel.password)
                    .keyboardType(.default)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            Button(action: {viewModel.SignIn()}){
                if viewModel.isLoading {
                    ProgressView().progressViewStyle(.circular)
                } else {
                    Text ("button.signin")
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .padding()
            
            HStack {
                Text ("text.signup")
                NavigationLink(destination: SignUpView()){
                    Text("button.signup")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
                .fullScreenCover(isPresented: $viewModel.isSignInOK) {
                    MainContentView()
                }
        }
    }
}
