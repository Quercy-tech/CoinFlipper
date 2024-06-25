//
//  ContentView.swift
//  CoinFlipper
//
//  Created by Quercy on 04.05.2024.
//
import SwiftUI

struct UserView: View { 
    @State private var viewModel = ViewModel()
    @ObservedObject var CurrencyList: Currencies
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(CurrencyList.items.sorted(), id: \.rates) { currency in
                let rateKeys = Array(currency.rates.keys)

                VStack(alignment: .leading) {
                  Text("Rates:")
                    
                  ForEach(rateKeys, id: \.self) { key in
                      let formattedAmount = viewModel.amount.replacingOccurrences(of: ",", with: ".")
                      let currencyAmount = (currency.rates[key] ?? 0.0) * (Double(formattedAmount) ?? 0.0)
                      Text("\(key): \(currencyAmount.formatted())")
                  }
                }
                .swipeActions {
                  Button(role: .destructive) {
                      CurrencyList.removeCurrency(currency)
                  } label: {
                    Image(systemName: "trash")
                  }
                }
              }
            }
            
            VStack {
                
                TextField("Enter an amount", text: $viewModel.amount)
                    .padding()
                    .background(Color.gray.opacity(0.10))
                    .cornerRadius(20.0)
                    .padding()
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                TextField("Enter a currency", text: $viewModel.base)
                    .padding()
                    .background(Color.gray.opacity(0.10))
                    .cornerRadius(20.0)
                    .padding()
                    .focused($isFocused)
               
                Button("Convert") {
                    isFocused = false
                    viewModel.makeRequest(currencies: CurrencyList.codes, CurrencyList: CurrencyList)
                }.padding()
            }
            .onAppear {
                viewModel.makeRequest(currencies: CurrencyList.codes, CurrencyList: CurrencyList)
               
            }
            .onChange(of: viewModel.base, {
                viewModel.makeRequest(currencies: CurrencyList.codes, CurrencyList: CurrencyList)
            })
            
            .navigationTitle("CoinFlipper")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Check currency in certain day", systemImage: "calendar") {
                        viewModel.showingDates = true
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingDates) {
                CalendarView(base: $viewModel.base, amount: $viewModel.amount, CurrencyList: CurrencyList)
            }
        }
    }
}

#Preview {
    UserView(CurrencyList: Currencies())
}

