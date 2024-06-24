//
//  UserView-ViewModel.swift
//  CoinFlipper
//
//  Created by Quercy on 22.06.2024.
//

import Foundation

extension UserView {
    
    @Observable
    class ViewModel {
        var base = "UAH"
        var amount = "1.0"
        var showingAddCurrency = false
        var enteredCurrencies = ["USD", "EUR", "GBP"]
        var showingDates = false
        var codesAndValues = [String: Double]()
        var count = 0
        
        func makeRequest(currencies: [String], CurrencyList: Currencies) {
            apiRequest(url: "https://api.currencybeacon.com/v1/latest?api_key=sn89Py12cds8QIa1wtjYMBpO6XVKYeWl&base=\(base)") { currency in
                CurrencyList.items = []
                
                for currency in currency.rates {
                    self.codesAndValues[currency.key] = currency.value
                    if currencies.contains(currency.key) {
                        CurrencyList.items.append(Currency(date: Date.now.formatted(), base: self.base, rates: [currency.key: currency.value]))
                        
                    }
                    
                }
            }
            
        }
    }
}
