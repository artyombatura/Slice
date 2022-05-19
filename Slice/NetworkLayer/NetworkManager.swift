//
//  NetworkManager.swift
//  Slice
//
//  Created by Artyom Batura on 12.05.22.
//

import Foundation

class NetworkCaller {
	static let shared = NetworkCaller()
	
	private let urlSession: URLSession = .shared
	private let jsonDecoder = JSONDecoder()
	
	private init() { }
	
	public func simpleCall(for endpoint: Endpoint, completion: @escaping (Result<Void, Error>) -> Void) {
		var request = URLRequest(url: endpoint.url)
		request.httpMethod = endpoint.method.rawValue
		request.httpBody = endpoint.body?.data()
		
		endpoint.headers.forEach({ (key, value) in
			if let value = value as? String {
				request.setValue(value, forHTTPHeaderField: key)
			}
		})

		let dataTask = urlSession
			.dataTask(with: request) { data, response, error in
				
				if let data = data {
					print("\n\n$0: Request \(endpoint.path) ended with data: \(String(data: data, encoding: .utf8))\n\n")
				}
				
				if let error = error {
					completion(.failure(error))
					return
				}
				
				completion(.success(()))
			}
		
		dataTask.resume()
	}
	
	public func call<T: Decodable>(for endpoint: Endpoint, resultType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
		var request = URLRequest(url: endpoint.url)
		request.httpMethod = endpoint.method.rawValue
		request.httpBody = endpoint.body?.data()
		
		endpoint.headers.forEach({ (key, value) in
			if let value = value as? String {
				request.setValue(value, forHTTPHeaderField: key)
			}
		})
		
		let dataTask = urlSession
			.dataTask(with: request) { data, response, error in
				if let error = error {
					completion(.failure(error))
					return
				}
				
				guard let data = data else {
					return
				}
		
				do {
					let model = try JSONDecoder().decode(T.self, from: data)
					completion(.success(model))
				} catch let error {
					completion(.failure(error))
				}
			}
		
		dataTask.resume()
	}
}

extension Dictionary {
	func data() -> Data? {
		guard let httpBody = try? JSONSerialization.data(withJSONObject: self, options: []) else {
			return nil
		}
		return httpBody
	}
}
