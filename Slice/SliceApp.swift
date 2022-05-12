//
//  SliceApp.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    
    @Published var user: User?
    
    @Published var currentOrder: Order?
    
    var newOrderSubject = PassthroughSubject<Order, Never>()
}

@main
struct SliceApp: App {
    @StateObject var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            if appViewModel.isUserLoggedIn {
                NavigationView(content: {
                    HomeView()
                })
                    .environmentObject(appViewModel)
            } else {
                NavigationView(content: {
                    LoginView()
//						.onAppear(perform: {
//							UserService().signup(login: "albert", password: "123", firstName: "Albert", lastName: "Test", email: "albert@gmail.com", completion: { _ in })
//						})
                })
                    .environmentObject(appViewModel)
            }
        }
    }
}
