//
//  RestaurantDetailView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI

struct Cart {
	var allDishes = [APIResults.DishAPI]()
    
    var totalSum: Double {
        var sum: Double = 0
		allDishes.forEach { sum += (Double($0.price) ?? 0.0) }
        return sum
    }
}

class RestaurantDetailViewModel: ObservableObject {
    
    @Published var selectedDate: Date = Date()
    
    @Published var isDelayedOrder: Bool = false
    
    @Published var cart = Cart()
    
}

struct RestaurantDetailView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @StateObject var viewModel = RestaurantDetailViewModel()
    
	var restaurant: APIResults.RestaurantAPI
    
    var gridItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()),]
    
    @State private var isDatePickVisible: Bool = false
	
	@State private var menu: [APIResults.DishAPI] = []
	
	let restsService: RestaurantServiceAPI = Service.Restaurant.shared
	
	@State private var errorText: String = ""
	@State private var isErrorDisplayed: Bool = false
    
    var body: some View {
        ZStack(content: {
            // MARK: - Main Section
            ScrollView(content: {
                VStack(content: {
                    SLProfileHeaderView(imageURL: restaurant.verifiedPhotoURL,
                                        title: "")
                    
                    Text(restaurant.description)
                        .padding(.horizontal, 16)
                    
                    Divider()
                    
                    NavigationLink(destination: {
                        CartView(cart: $viewModel.cart)
                    }, label: {
                        HStack(content: {
							Text("Корзина: \(viewModel.cart.totalSum.stringWithNDecimalPlaces(2)) руб.")
                                .font(.system(size: 20,
                                              weight: .bold,
                                              design: .rounded))
                                .shadow(radius: 10)
                        })
                    })
                    
                    
                    Divider()
                    
                    if isDatePickVisible {
                        DatePicker("Выберите время:", selection: $viewModel.selectedDate, in: Date()...)
                            .padding(.horizontal, 16)
                    }
                    
                    Divider()
                    
                    LazyVGrid(columns: gridItems, spacing: 16, content: {
                        ForEach(menu, id: \.id, content: { dish in
							NavigationLink(destination: { DishDetailView(dish: dish, addCallback: { viewModel.cart.allDishes.append($0) }) },
                                           label: {
                                DishView(dish: dish, addCallback: { dish in
                                    viewModel.cart.allDishes.append(dish)
                                })
                                    .aspectRatio(1.0, contentMode: .fill)
                            })
                        })
                    })
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                })
                .padding(.bottom, 70)
            })
            
            // MARK: - Order button section
            VStack(content: {
                Spacer()
                
                RoundedRectangle(cornerRadius: 100)
                    .foregroundColor(.white)
                    .frame(height: 60)
                    .shadow(radius: 10)
                    .overlay(
                        Text(viewModel.isDelayedOrder ? "Заказать на время" : "Заказать")
                    )
                    .onTapGesture {
						// MARK: - TODO
//                        print("Заказ отложенный? - \(viewModel.isDelayedOrder)")
//
//                        let newOrder = Order(id: UUID().uuidString,
//                                             isActive: true,
//                                             restaurantName: restaurant.name,
//                                             dishes: [])
////
//                        appViewModel.newOrderSubject.send(newOrder)
                    }
                    .onLongPressGesture(perform: {
                        isDatePickVisible.toggle()
                        
                        viewModel.isDelayedOrder.toggle()
                    })
            })
            .padding(.horizontal, 16)
        })
        .navigationTitle(restaurant.name)
		.alert(errorText,
			   isPresented: $isErrorDisplayed,
			   actions: { EmptyView() })
		.onAppear {
			restsService.fetchMenu(for: restaurant.id) { result in
				switch result {
				case let .success(menu):
					DispatchQueue.main.async {
						self.menu = menu
					}
				default: break
				}
			}
		}
    }
}
