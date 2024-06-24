//
//  AuthenticationView-ViewModel.swift
//  CoinFlipper
//
//  Created by Quercy on 21.06.2024.
//

import Foundation
import LocalAuthentication

extension AuthenticationView {
    
    
    @Observable
    class ViewModel {
        var username = ""
        var password = ""
        
        var isAdmin = false
         var isUser = false
        
         var showAlert = false
        var showAlertNoBiometrics = false
        
        var CurrencyList = Currencies()
        
        
        func authenticateUser(username: String, password: String) {
            if password.lowercased().replacingOccurrences(of: " ", with: "") == "admin" && username.lowercased().replacingOccurrences(of: " ", with: "") == "admin" {
                isAdmin = true
            } else {
                showAlert.toggle()
            }
        }
        
        func biometricsAuthenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUser = true
                    } else {
                        self.showAlertNoBiometrics = true
                    }
                }
            }
        }
    }
}
