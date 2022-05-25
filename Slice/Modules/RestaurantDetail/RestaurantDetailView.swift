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
	let restsService: RestaurantServiceAPI = Service.Restaurant.shared
	
	@Published var selectedDate: Date = .now.addingTimeInterval(OrderDatesActionsValidator.shared.secondsOffsetToBeDelayed)
    
    @Published var isDelayedOrder: Bool = false
    
    @Published var cart = Cart()
	
	@Published var errorText: String = ""
	@Published var isErrorDisplayed: Bool = false
	
	
	let enterDate: Date
	
	init() {
		self.enterDate = Date.now
	}
    
	func createOrder(restID: Int, completion: @escaping (APIResults.OrderAPI) -> Void) {
		// Проверяет есть ли в заказе хотя бы одно блюдо
		guard cart.allDishes.isNotEmpty else {
			self.errorText = "Добавьте в корзину хотя бы одно блюдо"
			self.isErrorDisplayed.toggle()
			return
		}
		
		// Проверяет введенные даты на соблюдение условия:
		// Если дата отложенного заказа больше текущий на 15 минут - заказ может быть отложенным
		// Если заказ планируется быть выполненым за 15 минут
		let isDelayedRequirementTrue = OrderDatesActionsValidator.shared.isCouldBeCreatedAsDelayed(selectedDate: selectedDate)
		
		if isDelayedOrder {
			guard isDelayedRequirementTrue else {
				self.errorText = "Отложенный заказ может быть создан только на время больше текущего на 15 минут. Пожалуйста проверьте заказ, убедитесь в правильности времени и попробуйте снова"
				self.isErrorDisplayed.toggle()
				return
			}
		}
		
		let dishesIDs: [Int] = cart.allDishes.map { $0.id }
	
		restsService.createOrder(restaurantID: restID,
								 dishesIDs: dishesIDs,
								 date: isDelayedOrder ? APIDatesFormatter.shared.dateToString(selectedDate) : nil) { result in
			if case let .success(order) = result {
				completion(order)
			}
		}
	}
}

struct RestaurantDetailView: View {
    @EnvironmentObject var appViewModel: AppViewModel
	@Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = RestaurantDetailViewModel()
    
	var restaurant: APIResults.RestaurantAPI
    
    var gridItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()),]
    
    @State private var isDatePickVisible: Bool = false
	
	@State private var menu: [APIResults.DishAPI] = []
    
    var body: some View {
        ZStack(content: {
            // MARK: - Main Section
            ScrollView(content: {
                VStack(content: {
                    SLProfileHeaderView(imageURL: restaurant.verifiedPhotoURL,
                                        title: "")
					
					// MARK: - Section with phone and adress
					HStack {
						Spacer()
						
						VStack {
							Text(restaurant.address)
							
							Text(restaurant.phoneNumber)
						}
						
						Spacer()
					}
					.padding(.vertical, 10)
                    
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
						let offsetDate = Date(timeIntervalSinceNow: OrderDatesActionsValidator.shared.secondsOffsetToBeDelayed)
                        DatePicker("Выберите время:", selection: $viewModel.selectedDate, in: offsetDate...)
                            .padding(.horizontal, 16)
							.onAppear {
//								self.viewModel.selectedDate = Date.now.addingTimeInterval(OrderDatesActionsValidator.shared.secondsOffsetToBeDelayed)
							}
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
						viewModel.createOrder(restID: restaurant.id) { order in
							appViewModel.newOrderSubject.send(order)
							DispatchQueue.main.async {
								presentationMode.wrappedValue.dismiss()
							}
						}

                    }
                    .onLongPressGesture(perform: {
                        isDatePickVisible.toggle()
                        
                        viewModel.isDelayedOrder.toggle()
                    })
            })
            .padding(.horizontal, 16)
        })
        .navigationTitle(restaurant.name)
		.alert(viewModel.errorText,
			   isPresented: $viewModel.isErrorDisplayed,
			   actions: { EmptyView() })
		.onAppear {
			viewModel.restsService.fetchMenu(for: restaurant.id) { result in
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
