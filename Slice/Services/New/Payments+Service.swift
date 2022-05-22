//
//  Payments+Service.swift
//  Slice
//
//  Created by Artyom Batura on 22.05.22.
//

import Foundation

protocol PaymentsService {
	func fetchAllPaymentMethods(completion: @escaping (Result<[APIResults.CardAPI], Service.ServiceError>) -> Void)
	
	func addPaymentMethod(number: String,
						  expiration: String,
						  cvc: String,
						  completion: @escaping (Result<Void, Service.ServiceError>) -> Void)
	
	func deletePaymentMethod(id: Int,
							 completion: @escaping (Result<Void, Service.ServiceError>) -> Void)
}

extension Service {
	final class Payments: PaymentsService {
		static let shared = Payments()
		
		private init() { }
		
		func fetchAllPaymentMethods(completion: @escaping (Result<[APIResults.CardAPI], Service.ServiceError>) -> Void) {
			guard let token = LocalUserService.shared.getToken() else {
				completion(.failure(.authTokenNotFound))
				return
			}
			let endpoint = Endpoint.Payments.getAllPaymentMethods(using: token)
			NetworkCaller.shared.call(for: endpoint,
										 resultType: [APIResults.CardAPI].self,
										 completion: completion)
		}
		
		func addPaymentMethod(number: String, expiration: String, cvc: String, completion: @escaping (Result<Void, Service.ServiceError>) -> Void) {
			guard let token = LocalUserService.shared.getToken() else {
				completion(.failure(.authTokenNotFound))
				return
			}
			let endpoint = Endpoint.Payments.addPaymentMethod(cardNumber: number, expirationDate: expiration, cvc: cvc, using: token)
			NetworkCaller.shared.simpleCall(for: endpoint, completion: completion)
		}
		
		func deletePaymentMethod(id: Int, completion: @escaping (Result<Void, Service.ServiceError>) -> Void) {
			guard let token = LocalUserService.shared.getToken() else {
				completion(.failure(.authTokenNotFound))
				return
			}
			let endpoint = Endpoint.Payments.deletePaymentMethod(id, using: token)
			NetworkCaller.shared.simpleCall(for: endpoint, completion: completion)
		}
	}
}
