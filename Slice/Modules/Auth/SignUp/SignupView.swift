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
	@State private var isErrorPresented: Bool = false
	@State private var errorText: String = ""
    
	// old
//    let userService: UserServiceProtocol = MockUserService()
	// new
	let userService: UserServiceAPI = Service.UserService.shared

    
    var body: some View {
		ScrollView {
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
					userService.signup(username: login,
									   firstName: firstName,
									   lastName: lastName,
									   email: email,
									   password: password) { _ in
						self.userService.login(username: login,
											   password: password) { result in
							switch result {
							case let .success(model):
								DispatchQueue.main.async {
									self.appViewModel.loggedUser = model.user
									self.appViewModel.isUserLoggedIn.toggle()
								}
							default:
								self.errorText = "Ошибка регистрации. Попробуйте снова."
								self.isErrorPresented.toggle()
							}
						}
					}
				} else {
					errorText = "Пожалуйста введите все данные и попробуйте снова."
					isErrorPresented.toggle()
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
			.alert(errorText,
				   isPresented: $isErrorPresented,
				   actions: { EmptyView() })
    }
}
