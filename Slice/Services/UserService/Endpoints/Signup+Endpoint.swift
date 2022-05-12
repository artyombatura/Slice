//
//  Signup+Endpoint.swift
//  Slice
//
//  Created by Artyom Batura on 12.05.22.
//

import Foundation

extension Endpoint {
	enum Signup {
		static func endpoint(username: String,
							 firstName: String,
							 lastName: String,
							 email: String,
							 password: String) -> Endpoint {
			let body: [String: Any] = [
				"username": username,
				"first_name": firstName,
				"last_name": lastName,
				"email": email,
				"password": password
			]
			
			return .init(method: .POST,
						 path: "/api/signup/",
						 body: body)
		}
	}
}
