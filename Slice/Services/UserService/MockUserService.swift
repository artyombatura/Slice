//
//  MockUserService.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation

class MockUserService: UserServiceProtocol {
    let user = User(id: UUID().uuidString,
                    username: "artyombatura",
                    name: "Артем",
                    surname: "Батура",
                    email: "artyombatura@gmail.com",
                    avatarURL: "https://i.pinimg.com/736x/26/bd/ad/26bdad3d88dd702a548f1cfe46513574.jpg")
    
    func login(login: String, password: String, completion: @escaping (User) -> Void) {
        
        completion(user)
    }
    
    func signup(login: String, password: String, firstName: String, lastName: String, email: String, completion: @escaping (User) -> Void) {
        completion(user)
    }
}
