//
//  Payments+Endpoint.swift
//  Slice
//
//  Created by Artyom Batura on 20.05.22.
//

import Foundation

extension Endpoint {
	enum Payments {
		static func addPaymentMethod(
			cardNumber: String,
			expirationDate: String,
			cvc: String,
			using token: String?
		) -> Endpoint {
			var authHeader: Endpoint.AuthHeaderField? = nil
			if let token = token {
				authHeader = ("Authorization", "Token \(token)")
			}
			return Endpoint(method: .POST,
							path: "/api/link-credit-card/",
							body: [
								"number": cardNumber,
								"expiration_date": expirationDate,
								"cvv": cvc
							],
							authHeader: authHeader)
		}
		
		static func getAllPaymentMethods(using token: String?) -> Endpoint {
			var authHeader: Endpoint.AuthHeaderField? = nil
			if let token = token {
				authHeader = ("Authorization", "Token \(token)")
			}
			return Endpoint(method: .GET,
							path: "/api/get-credit-cards/",
							authHeader: authHeader)
		}
		
		static func deletePaymentMethod(_ id: Int, using token: String?) -> Endpoint {
			var authHeader: Endpoint.AuthHeaderField? = nil
			if let token = token {
				authHeader = ("Authorization", "Token \(token)")
			}
			return Endpoint(method: .DELETE,
							path: "/api/delete-credit-card/\(id)/",
							authHeader: authHeader)
		}
	}
}
