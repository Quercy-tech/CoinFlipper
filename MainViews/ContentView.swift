//
//  ContentView.swift
//  CoinFlipper
//
//  Created by Quercy on 04.05.2024.
//
import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @ObservedObject  var CurrencyList: Currencies
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(CurrencyList.items, id: \.rates) { currency in
                    let rateKeys = Array(currency.rates.keys)
                    ForEach(rateKeys, id: \.self) { key in
                        if let index = self.CurrencyList.items.firstIndex(of: currency) {
                            
                            NavigationLink(destination: EditCurrencyView(currency: self.$CurrencyList.items[index], CurrencyList: CurrencyList, base: $viewModel.base, codesAndNames: $viewModel.codesAndNames, newFullName: viewModel.codesAndNames[key] ?? "Unknown country")) {
                                VStack(alignment: .leading) {
                                    Text("Rates:")
                                    ForEach(rateKeys, id: \.self) { key in
                                        let formattedAmount = viewModel.amount.replacingOccurrences(of: ",", with: ".")
                                        let currencyAmount = (currency.rates[key])! * (Double(formattedAmount)!)
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
                
                Button("Convert!") {
                    isFocused = false
                    viewModel.makeRequest(currencies: CurrencyList.codes, CurrencyList: CurrencyList)
                }.padding()
            }
            .navigationTitle("CoinFlipper Pro")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showingAddCurrency = true }) {
                        Label("Add a currency", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { viewModel.showingDates = true }) {
                        Label("Check currency on a certain day", systemImage: "calendar")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddCurrency) {
                AddView(CurrencyList: CurrencyList, base: $viewModel.base, codesAndValues: $viewModel.codesAndValues, codesAndNames: $viewModel.codesAndNames)
            }
            .sheet(isPresented: $viewModel.showingDates) {
                CalendarView(base: $viewModel.base, amount: $viewModel.amount, CurrencyList: CurrencyList)
            }
            
        }
        .onAppear {
            if viewModel.shouldMakeRequest {
                viewModel.makeRequest(currencies: CurrencyList.codes, CurrencyList: CurrencyList)
                viewModel.shouldMakeRequest = false
            }
        }
    }
    
    
}

#Preview {
    ContentView(CurrencyList: Currencies())
}

