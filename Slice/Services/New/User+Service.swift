//
//  User+Service.swift
//  Slice
//
//  Created by Artyom Batura on 20.05.22.
//

import Foundation

protocol UserServiceAPI {
	func signup(username: String,
				firstName: String,
				lastName: String,
				email: String,
				password: String,
				completion: @escaping (Result<Void, Error>) -> Void)
	
	func login(username: String, password: String, completion: @escaping (Result<APIResults.LoginResultModel, Error>) -> Void)
	
	func tryRelogin(completion: @escaping (Result<APIResults.LoginResultModel, Error>) -> Void)
	
	func logout()
	
	func saveToken(_ token: String)
	
	func getToken() -> String?
}

extension Service {
	final class UserService: UserServiceAPI {
		struct Constants {
			static let username = "username"
			static let password = "password"
			static let tokenKey = "user_token"
		}
		
		let userDefaults = UserDefaults.standard
		
		static let shared = Service.UserService()
		
		private init() { }
		
		func signup(username: String, firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
			let endpoint = Endpoint.Signup.endpoint(username: username,
													firstName: firstName,
													lastName: lastName,
													email: email,
													password: password)
			NetworkCaller.shared.simpleCall(for: endpoint, completion: completion)
		}
		
		func login(username: String, password: String, completion: @escaping (Result<APIResults.LoginResultModel, Error>) -> Void) {
			let endpoint = Endpoint.Login.endpoint(username: username, password: password)
			NetworkCaller.shared.call(for: endpoint,
										 resultType: APIResults.LoginResultModel.self,
										 completion: { result in
				switch result {
				case let .success(model):
					self.saveToken(model.authToken)
					self.saveCredentials(username: username, password: password)
					
					print("\n\n$0Успешная авторизация, модель пользователя: \(model.user)")
					print("\n\n$0Успешная авторизация, токен: \(model.authToken)\n\n")
				default: break
				}
				
				completion(result)
			})
		}
		
		func tryRelogin(completion: @escaping (Result<APIResults.LoginResultModel, Error>) -> Void) {
			if let _ = getToken(),
			   let creds = getCredentials() {
				login(username: creds.0,
					  password: creds.1,
					  completion: completion)
			}
		}
		
		func saveToken(_ token: String) {
			userDefaults.set(token, forKey: Constants.tokenKey)
		}
		
		func getToken() -> String? {
			userDefaults.value(forKey: Constants.tokenKey) as? String
		}
		
		func logout() {
			userDefaults.removeObject(forKey: Constants.tokenKey)
			userDefaults.removeObject(forKey: Constants.username)
			userDefaults.removeObject(forKey: Constants.password)
		}
		
		private func getCredentials() -> (String, String)? {
			guard let username = userDefaults.value(forKey: Constants.username) as? String,
				  let password = userDefaults.value(forKey: Constants.password) as? String else {
					  return nil
				  }
			return (username, password)
		}
		
		private func saveCredentials(username: String, password: String) {
			userDefaults.set(username, forKey: Constants.username)
			userDefaults.set(password, forKey: Constants.password)
		}
	}
}
