//
//  Orders+Endpoint.swift
//  Slice
//
//  Created by Artyom Batura on 19.05.22.
//

import Foundation

extension Endpoint {
	enum Orders {
		static func createOrderEndpoint(restaurantID: Int,
										dishesIDs: [Int],
										date: String? = nil,
										using token: String?) -> Endpoint {
			var authHeader: Endpoint.AuthHeaderField? = nil
			if let token = token {
				authHeader = ("Authorization", "Token \(token)")
			}
			var body: [String: Any] = [
				"restaurant": restaurantID,
				"dishes": dishesIDs
			]
			if let date = date {
				body["date"] = date
			}
			
			return Endpoint(method: .POST,
							path: "/api/create-order/",
							body: body,
							authHeader: authHeader)
		}
		
		static func updateOrderEndpoint(orderID: Int,
										with status: APIResults.OrderStatus,
										using token: String?) -> Endpoint {
			var authHeader: Endpoint.AuthHeaderField? = nil
			if let token = token {
				authHeader = ("Authorization", "Token \(token)")
			}
			return Endpoint(method: .PUT,
							path: "/api/update-order/\(orderID)/",
							body: [
								"status": status.rawValue
							],
							authHeader: authHeader)
		}
		
		static func deleteOrderEndpoint(orderID: Int,
										using token: String?) -> Endpoint {
			var authHeader: Endpoint.AuthHeaderField? = nil
			if let token = token {
				authHeader = ("Authorization", "Token \(token)")
			}
			return Endpoint(method: .DELETE,
							path: "/api/delete-order/\(orderID)/",
							authHeader: authHeader)
		}
		
		static func getHistoryEndpoint(using token: String?) -> Endpoint {
			var authHeader: Endpoint.AuthHeaderField? = nil
			if let token = token {
				authHeader = ("Authorization", "Token \(token)")
			}
			return Endpoint(method: .GET,
							path: "/api/get-orders-history/",
							authHeader: authHeader)
		}
	}
}
