//
//  SignupView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI

struct SignupView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var login: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    let userService: UserServiceProtocol = MockUserService()
    
    var body: some View {
        VStack(content: {
            
            Text("SLICE")
                .font(.system(size: 30,
                              weight: .bold,
                              design: .rounded))
                .shadow(radius: 10)
            
            Spacer()
            
            VStack(spacing: 20, content: {
                TextField("Логин", text: $login)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.black)
                    )
                
                TextField("Имя", text: $firstName)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.black)
                    )
                
                TextField("Фамилия", text: $lastName)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.black)
                    )
                
                TextField("Email", text: $email)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.black)
                    )
                
                SecureField("Пароль", text: $password)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.black)
                    )
            })
                .padding(.horizontal, 20)
            
            
            
            Button(action: {
                if !login.isEmpty &&
                    !password.isEmpty &&
                    !firstName.isEmpty &&
                    !lastName.isEmpty &&
                    !email.isEmpty {
                    userService.signup(login: login,
                                       password: password,
                                       firstName: firstName,
                                       lastName: lastName,
                                       email: email,
                                       completion: { user in
                        appViewModel.user = user
                        
                        appViewModel.isUserLoggedIn.toggle()
                    })
                }
            }, label: {
                RoundedRectangle(cornerRadius: 100)
                    .shadow(radius: 10)
                    .overlay(
                        Text("Войти")
                            .foregroundColor(.white)
                    )
            })
                .frame(height: 60)
                .padding(.horizontal, 16)
                .padding(.top, 40)
            
            Spacer()
        })
    }
}
