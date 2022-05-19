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
	}
}
