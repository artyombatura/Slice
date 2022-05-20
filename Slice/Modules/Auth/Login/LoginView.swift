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
	@State private var isErrorPresented: Bool = false
    
	// old
//    let userService: UserServiceProtocol = MockUserService()
	// new
	let userService: UserServiceAPI = Service.UserService.shared
    
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
					userService.login(username: login,
									  password: password) { result in
						switch result {
						case let .success(model):
							DispatchQueue.main.async {
								self.appViewModel.loggedUser = model.user
								self.appViewModel.isUserLoggedIn.toggle()
							}
						default:
							isErrorPresented.toggle()
						}
					}
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
			.alert("Ошибка авторизации. Попробуйте снова.",
				   isPresented: $isErrorPresented,
				   actions: { EmptyView() })
    }
}
