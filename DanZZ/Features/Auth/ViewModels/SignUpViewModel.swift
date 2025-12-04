//
//  SignUpViewModel.swift
//  DanZZ
//
//  Created by Hong Lu on 03/12/2025.
//

import Foundation
import FirebaseAuth
import Combine

class SignUpViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSignUpOK = false
    
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmpwd = ""
    
    var isFormValid: Bool {
        return !name.isEmpty && !password.isEmpty && !confirmpwd.isEmpty && password == confirmpwd
    }
    
    func signUp() {
        guard isFormValid else {
            errorMessage = "please ensure all the fields are filled and passwords match"
            isLoading = false
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] authResult, error in
            DispatchQueue.main.async() {
                self?.isLoading = false
            }
            
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async() {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                print("Firebase Sign Up Error: \(error.localizedDescription)")
                return
            } else if authResult != nil {
                let user = authResult?.user
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { updateError in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.isSignUpOK = true
                    }
                    
                }
            }
        }
    }
}
