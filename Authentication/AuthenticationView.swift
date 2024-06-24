//
//  AuthenticationView.swift
//  CoinFlipper
//
//  Created by Quercy on 09.05.2024.
//
import LocalAuthentication
import SwiftUI

struct AuthenticationView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    TextField("Username", text: $viewModel.username)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    Button(action: {
                        viewModel.authenticateUser(username: viewModel.username, password: viewModel.password)
                    }) {
                        Text("Login as admin")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.blue.opacity(0.4))
                            .cornerRadius(10)
                    }
                    .alert("Wrong credetentials", isPresented: $viewModel.showAlert) {} message: {
                        Text("Wrong username or password. Try again")
                    }
                    
                    Button("Login", action: viewModel.biometricsAuthenticate)
                        .foregroundStyle(.white)
                        .frame(width: 300,height: 50)
                        .background(Color.blue.opacity(0.4))
                        .cornerRadius(10)
                        .contentShape(.rect)
                        .alert("No biometrics", isPresented: $viewModel.showAlertNoBiometrics) {} message: {
                            Text("No biometrics found on your device. For security reasons you can't use our app.")
                        }
                    
                    Spacer()
                    
                    Text("App created by Oleksii Hezha")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Logo created by Happy girl from Noun project")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                        .navigationDestination(isPresented: $viewModel.isAdmin) {
                            ContentView(CurrencyList: viewModel.CurrencyList)
                        }
                    
                        .navigationDestination(isPresented: $viewModel.isUser) {
                            UserView(CurrencyList: viewModel.CurrencyList)
                        }
                    
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    
}

#Preview {
    AuthenticationView()
}
