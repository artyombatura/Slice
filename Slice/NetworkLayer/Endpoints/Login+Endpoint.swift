//
//  Login+Endpoint.swift
//  Slice
//
//  Created by Artyom Batura on 19.05.22.
//

import Foundation

extension Endpoint {
	enum Login {
		static func endpoint(username: String,
							 password: String) -> Endpoint {
			let body: [String: Any] = [
				"username": username,
				"password": password
			]
			
			return .init(method: .POST,
						 path: "/api/login/",
						 body: body)
		}
	}
}
