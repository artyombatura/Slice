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
                    password: "https://i.pinimg.com/736x/26/bd/ad/26bdad3d88dd702a548f1cfe46513574.jpg")
    
    func login(login: String, password: String, completion: @escaping (User?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            completion(self.loginProccess(login: login, password: password))
        })
    }
    
    func signup(login: String, password: String, firstName: String, lastName: String, email: String, completion: @escaping (User?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            completion(self.signupProccess(login: login,
                                      password: password,
                                      firstName: firstName,
                                      lastName: lastName,
                                      email: email))
        })
    }
}

extension MockUserService {
    func loginProccess(login: String, password: String) -> User? {
        if let path = Bundle.main.path(forResource: "MockedUsers", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                let jsonDecoder = JSONDecoder()
                
                if let users = try? jsonDecoder.decode([User].self, from: data) {
                    
                        let loggedIn = users.first {
                            ($0.username == login) && ($0.password == password)
                        }
                    
                        return loggedIn
                }
            }
        }
        
        return nil
    }
    
    func signupProccess(login: String, password: String, firstName: String, lastName: String, email: String) -> User? {
        
        if let path = Bundle.main.path(forResource: "MockedUsers", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                let jsonDecoder = JSONDecoder()
                
                if let users = try? jsonDecoder.decode([User].self, from: data) {
                    let newUser = User(id: UUID().uuidString,
                                       username: login,
                                       name: firstName,
                                       surname: lastName,
                                       email: email,
                                       password: password)
                    
                    
                    let alllUsersJsonSTart = "["
                    
                    var allUsersContent = ""
                    users.forEach { user in
                        allUsersContent.append(user.jsonRep + ",")
                    }
                    
                    allUsersContent.append(newUser.jsonRep)
                    
                    let end = "]"
                    
                    var _ = alllUsersJsonSTart + allUsersContent + end

                    return newUser
                }
            }
        }
        
        return nil
    }
}
