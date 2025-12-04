//
//  LocalManager.swift
//  DanZZ
//
//  Created by Hong Lu on 04/12/2025.
//

import Foundation
import Combine

class LocalManager: ObservableObject {
    static let key = "DanZZAppLanguageCode"
    @Published var currentLocale: Locale
    static let availableLanguages = [
        Language(name: "English", code: "en"),
        Language(name: "中文 (简体)", code: "zh-Hans"),
        Language(name: "Norsk (Bokmål)", code: "nb")
    ]
    
    init() {
        let code = UserDefaults.standard.string(forKey: LocalManager.key) ?? "en"
        self.currentLocale = Locale(identifier: code)
        
    }
    static func getAvailableLanguages() -> [Language] {
        return availableLanguages
    }
    
    func getCurrentLocal() -> String {
        return currentLocale.identifier
    }
    
    func setCurrentLocal(_ code: String) {
        guard currentLocale.identifier != code else { return }
        UserDefaults.standard.set(code, forKey: LocalManager.key)
        
        DispatchQueue.main.async {
            self.currentLocale = Locale(identifier: code)
        }
    }
}

struct Language: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    
}
