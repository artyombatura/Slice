//
//  Endpoint.swift
//  Slice
//
//  Created by Artyom Batura on 12.05.22.
//

import Foundation

struct Endpoint {
	typealias AuthHeaderField = (key: String, value: Any)
	
	var apiBaseURL: String
	var method: HTTPMethod
	var path: String
	var queryItems: [URLQueryItem]?
	var body: [String: Any]?
	
	var authHeader: AuthHeaderField?
	
	init(apiBaseURL: String = "http://127.0.0.1:8000",
		 method: HTTPMethod,
		 path: String,
		 queryItems: [URLQueryItem]? = nil,
		 body: [String: Any]? = nil,
		 authHeader: AuthHeaderField? = nil) {
		self.apiBaseURL = apiBaseURL
		self.method = method
		self.path = path
		self.queryItems = queryItems
		self.body = body
		self.authHeader = authHeader
	}
	
	var url: URL {
		guard var components = URLComponents(string: apiBaseURL) else {
			preconditionFailure("Invalid server URL")
		}

		components.path = path
		components.queryItems = queryItems

		guard let url = components.url else {
			preconditionFailure("Invalid URL components: \(components)")
		}

		return url
	}
	
	var headers: [String: Any] {
		var headers = [
			"Accept": "*/*",
			"Accept-Encoding": "gzip",
			"Connection": "keep-alive",
			"Content-Type": "application/json"
		] as [String: Any]
		
		if let authHeader = authHeader {
			headers[authHeader.key] = authHeader.value
		}
		
		return headers
	}
}
