//
//  AuthCheckViewModel.swift
//  DanZZ
//
//  Created by Hong Lu on 05/12/2025.
//

import Foundation
import FirebaseAuth
import Combine

class AuthCheckViewModel: ObservableObject {
    @Published var isAuthenticated: Bool? = nil
    
    func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener {auth, user in
            DispatchQueue.main.async {
                if user != nil {
                    self.isAuthenticated = true
                } else {
                    self.isAuthenticated = false
                }
            }
            
        }
    }
}
