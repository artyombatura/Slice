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
						.onAppear {
							// MARK: - Test Signup + Login
							
//							TestNetworkExecutor.execute(TestEndpoints.signup.endpoint, completion: {
//								TestNetworkExecutor.executeWithDecoding(for: APIResults.LoginResultModel.self,
//																		   TestEndpoints.login.endpoint)
//							})
							
							// MARK: - All restaurants
							
//							TestNetworkExecutor.executeWithDecoding(for: [APIResults.RestaurantAPI].self,
//																	   TestEndpoints.allRestaurants.endpoint)
							
							// MARK: - Restaurant menu
							
//							TestNetworkExecutor.executeWithDecoding(for: [APIResults.DishAPI].self,
//																	   TestEndpoints.restaurantMenu(id: 1).endpoint)
							
							// MARK: - Create order
							
							// without date
//							TestNetworkExecutor.executeWithDecoding(for: APIResults.OrderAPI.self,
//																	   TestEndpoints.createOrder(
//																		restaurantID: 1,
//																		dishesIDs: [1, 2],
//																		date: nil,
//																		token: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7"
//																	   ).endpoint)
							
							// with date
//							TestNetworkExecutor.executeWithDecoding(for: APIResults.OrderAPI.self,
//																	   TestEndpoints.createOrder(
//																		restaurantID: 1,
//																		dishesIDs: [1, 2],
//																		date: "2022-05-20T15:40:40",
//																		token: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7"
//																	   ).endpoint)
						}
                })
                    .environmentObject(appViewModel)
            }
        }
    }
}
