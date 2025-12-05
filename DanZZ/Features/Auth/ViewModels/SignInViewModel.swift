//
//  SignInViewModel.swift
//  DanZZ
//
//  Created by Hong Lu on 03/12/2025.
//

import Foundation
import FirebaseAuth
import Combine

class SingInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var isSignInOK = false
    @Published var errorMessage = ""
    
    var isFormValid: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    func SignIn() {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard isFormValid else {
            self.errorMessage = "Please fill the email and password"
            self.isLoading = false
            return 
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else if authResult != nil {
                print("login successful")
            }
        }
    }
}

