//
//  ProfileViewModel.swift
//  DanZZ
//
//  Created by Hong Lu on 03/12/2025.
//

import Foundation
import Combine
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var name = Auth.auth().currentUser?.displayName
    @Published var email = Auth.auth().currentUser?.email
    @Published var isLoading = false
    private let localManager: LocalManager
    @Published var selectedLanguageCode: String
    
    init (localeManger: LocalManager) {
        self.selectedLanguageCode = localeManger.getCurrentLocal()
        self.localManager = localeManger
    }
    func signOut() {
            DispatchQueue.main.async {
                self.isLoading = true
            }

            do {
                try Auth.auth().signOut()
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("User successfully signed out.")
                }

            } catch let signOutError as NSError {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Error signing out: \(signOutError.localizedDescription)")
                }
            }
        }
    
    func setLanguage () {
        self.localManager.setCurrentLocal(selectedLanguageCode)
    }
    
}
