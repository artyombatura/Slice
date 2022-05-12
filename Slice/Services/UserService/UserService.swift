//
//  UserService.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation

protocol UserServiceProtocol {
    func login(login: String,
               password: String,
               completion: @escaping (User) -> Void)
    
    func signup(login: String,
                password: String,
                firstName: String,
                lastName: String,
                email: String,
                completion: @escaping (User) -> Void)
}

public final class UserService: UserServiceProtocol {
	func signup(login: String, password: String, firstName: String, lastName: String, email: String, completion: @escaping (User) -> Void) {
		let endpoint = Endpoint.Signup.endpoint(username: login,
												firstName: firstName,
												lastName: lastName,
												email: email,
												password: password)
		NetworkCaller.shared.simpleCall(for: endpoint, completion: { result in
			switch result {
			case .success:
				print("User created")
			case .failure:
				print("Signup failed")
			}
		})
	}
	
	func login(login: String, password: String, completion: @escaping (User) -> Void) {
		
	}
}
