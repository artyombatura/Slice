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
    
	//
	// old
    @Published var user: User?
	// new
	@Published var loggedUser: APIResults.UserAPI?
	//
	
    @Published var currentOrder: Order?
    
    var newOrderSubject = PassthroughSubject<Order, Never>()
}

@main
struct SliceApp: App {
    @StateObject var appViewModel = AppViewModel()
	
	private let userService: Service.UserService = Service.UserService.shared
    
    var body: some Scene {
        WindowGroup {
			ZStack {
				if appViewModel.isUserLoggedIn {
					NavigationView(content: {
						HomeView()
					})
						.environmentObject(appViewModel)
				} else {
					NavigationView(content: {
						LoginView()
							
					})
						.environmentObject(appViewModel)
				}
			}
			.onAppear {
				userService.tryRelogin { result in
					switch result {
					case let .success(model):
						DispatchQueue.main.async {
							self.appViewModel.loggedUser = model.user
							self.appViewModel.isUserLoggedIn.toggle()
						}
					default: break
					}
				}
			}
		}
    }
}

//	.onAppear {
//		// MARK: - Test Signup + Login
//
////							TestNetworkExecutor.execute(TestEndpoints.signup.endpoint, completion: {
////								TestNetworkExecutor.executeWithDecoding(for: APIResults.LoginResultModel.self,
////																		   TestEndpoints.login.endpoint)
////							})
//
//		// MARK: - All restaurants
//
////							TestNetworkExecutor.executeWithDecoding(for: [APIResults.RestaurantAPI].self,
////																	   TestEndpoints.allRestaurants.endpoint)
//
//		// MARK: - Restaurant menu
//
////							TestNetworkExecutor.executeWithDecoding(for: [APIResults.DishAPI].self,
////																	   TestEndpoints.restaurantMenu(id: 1).endpoint)
//
//		// MARK: - Create order
//
//		// without date
////							TestNetworkExecutor.executeWithDecoding(for: APIResults.OrderAPI.self,
////																	   TestEndpoints.createOrder(
////																		restaurantID: 1,
////																		dishesIDs: [1, 2],
////																		date: nil,
////																		token: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7"
////																	   ).endpoint)
//
//		// with date
////							TestNetworkExecutor.executeWithDecoding(for: APIResults.OrderAPI.self,
////																	   TestEndpoints.createOrder(
////																		restaurantID: 1,
////																		dishesIDs: [1, 2],
////																		date: "2022-05-20T15:40:40",
////																		token: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7"
////																	   ).endpoint)
//
//		// MARK: - Update order
////							TestNetworkExecutor.executeWithDecoding(for: APIResults.OrderAPI.self,
////																	   TestEndpoints.updateOrder(
////																		orderID: 17,
////																		status: .delayed,
////																		token: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7").endpoint)
//
//		// MARK: - Delete order
////							TestNetworkExecutor.execute(Endpoint.Orders.deleteOrderEndpoint(orderID: 16,
////																							using: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7"),
////														completion: { })
//
//		// MARK: - Get orders history
//
////							TestNetworkExecutor.executeWithDecoding(for: [APIResults.OrderAPI].self,
////																	   Endpoint.Orders.getHistoryEndpoint(using: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7"))
//
//		// MARK: - Last visited rests
//
////							TestNetworkExecutor.executeWithDecoding(for: [APIResults.RestaurantAPI].self,
////																	   TestEndpoints.lastVisitedRestaurants(token: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7").endpoint)
//
//		// MARK: - Popular rests
//
////							TestNetworkExecutor.executeWithDecoding(for: [APIResults.RestaurantAPI].self,
////																	   Endpoint.ListRestaurants.popularRestaurants())
//
//		// MARK: - Add payment method
//
////							TestNetworkExecutor.execute(TestEndpoints.addPaymentMethod(
////								cardNumber: "1234567812345678",
////								expirationDate: "1226",
////								cvc: "111",
////								token: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7"
////							).endpoint, completion: { })
//
//		// MARK: - Get all payment methods
//
////							TestNetworkExecutor.executeWithDecoding(for: [APIResults.CardAPI].self,
////																	   Endpoint.Payments.getAllPaymentMethods(using: "5d6d90c3dd846b87aebd7c0177c5b9e71cf942c7"))
//	}
