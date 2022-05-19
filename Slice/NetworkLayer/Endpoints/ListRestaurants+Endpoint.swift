//
//  ListRestaurants+Endpoint.swift
//  Slice
//
//  Created by Artyom Batura on 19.05.22.
//

import Foundation

extension Endpoint {
	enum ListRestaurants {
		// MARK: - All restaurants
		
		static func allRestaurantsEndpoint() -> Endpoint {
			return Endpoint(method: .GET,
							path: "/api/restaurants/")
		}
		
		static func restaurantMenuEndpoint(with id: Int) -> Endpoint {
			return Endpoint(method: .GET,
							path: "/api/get-restaurant-menu/",
							queryItems: [.init(name: "id", value: String(id))])
		}
		
		// MARK: - Popular restaurants
		
		// MARK: - Last visited restaurants
	}
}
