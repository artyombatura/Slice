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
	}
}

extension Service {

}
