//
//  CalendarView-ViewModel.swift
//  CoinFlipper
//
//  Created by Quercy on 22.06.2024.
//

import Foundation

extension CalendarView {
    
    @Observable
    class ViewModel {
        var enteredDate = Date.now
        var currencyList = [String]()
        var enteredValue = "1.0"        
        var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: enteredDate)
        }
    }
    
    func FormatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
        
    
    func makeTimeRequest(date: String, currencies: [String], viewModel: ViewModel) {
        apiRequest(url: "https://api.currencybeacon.com/v1/historical?api_key=sn89Py12cds8QIa1wtjYMBpO6XVKYeWl&base=\(base)&date=\(date)") { currency in
            var tempList = [String]()
            
            for currency in currency.rates {
                if currencies.contains(currency.key) {
                    tempList.append("\(currency.key) \(String(format: "%.4f", currency.value * (Double(amount) ?? 0.0)))")
                }
                tempList.sort()
            }
            viewModel.currencyList = tempList
        }
    }
}
