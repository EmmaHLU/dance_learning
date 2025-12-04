//
//  SignUpView.swift
//  DanZZ
//
//  Created by Hong Lu on 03/12/2025.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack {
            Text("button.creatAccount")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                TextField("profile.name", text: $viewModel.name)
                    .keyboardType(.namePhonePad)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                TextField("profile.email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                SecureField("signin.password", text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                SecureField("button.confirmPwd", text: $viewModel.confirmpwd)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            Button(action: {viewModel.signUp()}) {
                if viewModel.isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("button.signup")
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
            
            Spacer()
            
                .fullScreenCover(isPresented: $viewModel.isSignUpOK) {
                    Text ("signup.complete")
                }
        }
        .padding(.top, 50)
    }
}
