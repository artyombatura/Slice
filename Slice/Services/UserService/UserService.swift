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
