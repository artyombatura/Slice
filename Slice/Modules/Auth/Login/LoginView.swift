//
//  LoginView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var login: String = ""
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
                if !login.isEmpty && !password.isEmpty {
                    
                    userService.login(login: login,
                                      password: password,
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
            
            NavigationLink(destination: SignupView(),
                           label: {
                Text("Создать аккаунт")
                    .underline()
            })
            
            Spacer()
        })
    }
}
