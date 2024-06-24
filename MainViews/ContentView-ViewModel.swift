//
//  ContentView-ViewModel.swift
//  CoinFlipper
//
//  Created by Quercy on 21.06.2024.
//

import Foundation

extension ContentView {
    
    @Observable
    class ViewModel {
         var base = "UAH"
         var amount = "1.0"
         var showingAddCurrency = false
        //var inputIsFocused = false
        
        var showingDates = false
        var showingEditCurrency = false
        
        var codesAndValues = [String: Double]()
        var codesAndNames = [String: String]()
        
         var shouldMakeRequest = true
        
        func currencyName(currencyCode: String) -> String {
            
            let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode]))
            return locale.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
        }
        
        func makeRequest(currencies: [String], CurrencyList: Currencies) {
               apiRequest(url: "https://api.currencybeacon.com/v1/latest?api_key=sn89Py12cds8QIa1wtjYMBpO6XVKYeWl&base=\(base)") { currency in
                   DispatchQueue.main.async { // Ensure UI updates are on main thread
                       CurrencyList.items = []
                       self.codesAndValues = [:]
                       self.codesAndNames = [:]
                       
                       for currency in currency.rates {
                           self.codesAndValues[currency.key] = currency.value
                           self.codesAndNames[currency.key] = self.currencyName(currencyCode: currency.key)
                           if currencies.contains(currency.key) {
                               CurrencyList.items.append(Currency(date: Date.now.formatted(), base: self.base, rates: [currency.key: currency.value]))
                           }
                       }
                   }
               }
           }
    }
}
