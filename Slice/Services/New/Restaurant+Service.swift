//
//  Restaurant+Service.swift
//  Slice
//
//  Created by Artyom Batura on 20.05.22.
//

import Foundation

protocol RestaurantServiceAPI {
	func fetchAllRests(completion: @escaping (Result<[APIResults.RestaurantAPI], Service.ServiceError>) -> Void)
	
	func fetchPopularRests(completion: @escaping (Result<[APIResults.RestaurantAPI], Service.ServiceError>) -> Void)
	
	func fetchLastVisitedRests(completion: @escaping (Result<[APIResults.RestaurantAPI], Service.ServiceError>) -> Void)
	
	func fetchMenu(for id: Int, completion: @escaping (Result<[APIResults.DishAPI], Service.ServiceError>) -> Void)
	
	func createOrder(restaurantID: Int,
					 dishesIDs: [Int],
					 date: String?,
					 completion: @escaping (Result<APIResults.OrderAPI, Service.ServiceError>) -> Void)
	
	func ordersHistory(completion: @escaping (Result<[APIResults.OrderAPI], Service.ServiceError>) -> Void)
	
	func updateOrder(_ id: Int,
					 updateWith status: APIResults.OrderStatus,
					 completion: @escaping (Result<APIResults.OrderAPI, Service.ServiceError>) -> Void)
}

extension Service {
	final class Restaurant: RestaurantServiceAPI {
		static let shared = Restaurant()
		
		private init() { }
		
		// MARK: - All rests
		
		func fetchAllRests(completion: @escaping (Result<[APIResults.RestaurantAPI], Service.ServiceError>) -> Void) {
			let endpoint = Endpoint.ListRestaurants.allRestaurantsEndpoint()
			NetworkCaller.shared.call(for: endpoint,
										 resultType: [APIResults.RestaurantAPI].self,
										 completion: completion)
		}
		
		// MARK: - Popular rests
		
		func fetchPopularRests(completion: @escaping (Result<[APIResults.RestaurantAPI], Service.ServiceError>) -> Void) {
			let endpoint = Endpoint.ListRestaurants.popularRestaurants()
			NetworkCaller.shared.call(for: endpoint,
										 resultType: [APIResults.RestaurantAPI].self,
										 completion: completion)
		}
		
		// MARK: - Last visited rests
		
		func fetchLastVisitedRests(completion: @escaping (Result<[APIResults.RestaurantAPI], Service.ServiceError>) -> Void) {
			guard let token = LocalUserService.shared.getToken() else {
				completion(.failure(.authTokenNotFound))
				return
			}
			let endpoint = Endpoint.ListRestaurants.lastVisitedRestaurants(using: token)
			NetworkCaller.shared.call(for: endpoint,
										 resultType: [APIResults.RestaurantAPI].self,
										 completion: completion)
		}
		
		// MARK: - Create order
		
		func createOrder(restaurantID: Int,
						 dishesIDs: [Int],
						 date: String? = nil,
						 completion: @escaping (Result<APIResults.OrderAPI, Service.ServiceError>) -> Void) {
			guard let token = LocalUserService.shared.getToken() else {
				completion(.failure(.authTokenNotFound))
				return
			}
			let endpoint = Endpoint.Orders.createOrderEndpoint(restaurantID: restaurantID,
															   dishesIDs: dishesIDs,
															   date: date,
															   using: token)
			NetworkCaller.shared.call(for: endpoint,
										 resultType: APIResults.OrderAPI.self,
										 completion: completion)
		}
		
		// MARK: - Update order
		
		func updateOrder(_ id: Int,
						 updateWith status: APIResults.OrderStatus,
						 completion: @escaping (Result<APIResults.OrderAPI, ServiceError>) -> Void) {
			guard let token = LocalUserService.shared.getToken() else {
				completion(.failure(.authTokenNotFound))
				return
			}
			let endpoint = Endpoint.Orders.updateOrderEndpoint(orderID: id,
															   with: status,
															   using: token)
			NetworkCaller.shared.call(for: endpoint,
										 resultType: APIResults.OrderAPI.self,
										 completion: completion)
		}
		
		func ordersHistory(completion: @escaping (Result<[APIResults.OrderAPI], Service.ServiceError>) -> Void) {
			guard let token = LocalUserService.shared.getToken() else {
				completion(.failure(.authTokenNotFound))
				return
			}
			let endpoint = Endpoint.Orders.getHistoryEndpoint(using: token)
			NetworkCaller.shared.call(for: endpoint,
										 resultType: [APIResults.OrderAPI].self,
										 completion: completion)
		}
		
		// MARK: - Fetch menu
		
		func fetchMenu(for id: Int, completion: @escaping (Result<[APIResults.DishAPI], Service.ServiceError>) -> Void) {
			let endpoint = Endpoint.ListRestaurants.restaurantMenuEndpoint(with: id)
			NetworkCaller.shared.call(for: endpoint,
										 resultType: [APIResults.DishAPI].self,
										 completion: completion)
		}
	}
}
