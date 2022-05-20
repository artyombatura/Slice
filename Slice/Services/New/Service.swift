//
//  Service.swift
//  Slice
//
//  Created by Artyom Batura on 20.05.22.
//

import Foundation

enum Service { }

extension Service {
	enum ServiceError: Error {
		case authTokenNotFound
		
		case notFound
		
		case decodingFailed(String)
		
		case other(String)
	}
}

extension Service {
	typealias LocalUserService = Service.UserService
}
