//
//  CalendarView.swift
//  CoinFlipper
//
//  Created by Quercy on 09.05.2024.
//

import SwiftUI



struct CalendarView: View {
    
    @State private var viewModel = ViewModel()
    @Binding var base:String
    @Binding var amount:String
    @ObservedObject var CurrencyList: Currencies
    
    var body: some View {
        NavigationStack {
            DatePicker("Please enter a date", selection: $viewModel.enteredDate, in: Date.now.addingTimeInterval(-86400 * 15000)...Date.now , displayedComponents: [.date])
                .labelsHidden()
                .datePickerStyle(GraphicalDatePickerStyle())
                .onAppear{
                    makeTimeRequest(date:FormatDate(date: viewModel.enteredDate), currencies: CurrencyList.codes, viewModel: viewModel)
                }
            List {
                ForEach(viewModel.currencyList, id: \.self) { currency in
                    Text(currency)
                }
                
                .onChange(of: viewModel.enteredDate, { oldValue, newValue in
                    makeTimeRequest(date: FormatDate(date: newValue), currencies: CurrencyList.codes, viewModel: viewModel)
                })
                
                
            }
            .navigationTitle("Enter a date: ")
        }
        
    }
    
    
}

#Preview {
    CalendarView(base: .constant("UAH"), amount: .constant("1000.0"), CurrencyList: Currencies())
}
