//
//  TestNetworkExecutor.swift
//  Slice
//
//  Created by Artyom Batura on 19.05.22.
//

import Foundation

enum TestEndpoints {
	case signup(username: String, email: String, password: String)
	case login(username: String, password: String)
	
	case allRestaurants
	case restaurantMenu(id: Int)
	
	case createOrder(restaurantID: Int,
					 dishesIDs: [Int],
					 date: String? = nil,
					 token: String?)
}

extension TestEndpoints {
	var endpoint: Endpoint {
		switch self {
		// MARK: - Signup
			
		case let .signup(username, email, password):
			return Endpoint.Signup.endpoint(
				username: username,
				firstName: "Артем",
				lastName: "Батура",
				email: email,
				password: password
			)
			
		// MARK: - Login
			
		case let .login(username, password):
			return Endpoint.Login.endpoint(
				username: username,
				password: password
			)
			
		// MARK: - All rests
			
		case .allRestaurants:
			return Endpoint.ListRestaurants.allRestaurantsEndpoint()
			
		// MARK: - Rest menu
			
		case let .restaurantMenu(id):
			return Endpoint.ListRestaurants.restaurantMenuEndpoint(with: id)
			
		// MARK: - Create order
		case let .createOrder(restaurantID, dishesIDs, date, token):
			return Endpoint.Orders.createOrderEndpoint(restaurantID: restaurantID, dishesIDs: dishesIDs, date: date, using: token)
		}
	}
}

class TestNetworkExecutor {
	static func execute(_ endpoint: Endpoint, completion: @escaping () -> Void) {
		NetworkCaller.shared.simpleCall(for: endpoint, completion: { _ in
			completion()
		})
	}
	
	static func executeWithDecoding<T: Decodable>(for type: T.Type, _ endpoint: Endpoint) {
		NetworkCaller.shared.call(for: endpoint, resultType: T.self) { result in
			switch result {
			case let .success(model):
				print("\n\nTest executor for \(endpoint.path) finished with model: \(model)\n\n")
			case let .failure(error):
				print("\n\nTest executor for \(endpoint.path) finished with error: \(error)\n\n")
			}
		}
	}
}


