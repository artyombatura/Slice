//
//  ProfileView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
	let restaurantsService: RestaurantServiceAPI = Service.Restaurant.shared
    
    var newOrderSubject: PassthroughSubject<APIResults.OrderAPI, Never>
    
    @Published var orders = [APIResults.OrderAPI]()
    
	@Published var latestRestaurants = [APIResults.RestaurantAPI]()
    
	@Published var totalSumSpent: Double = 0.0
    
    var cancellableStore = Set<AnyCancellable>()
    
    init(newOrderSubject: PassthroughSubject<APIResults.OrderAPI, Never>) {
        self.newOrderSubject = newOrderSubject
        
        newOrderSubject
            .receive(on: DispatchQueue.main)
            .sink { newOrder in
                self.orders.insert(newOrder, at: 0)
            }
            .store(in: &cancellableStore)
		
		restaurantsService.fetchLastVisitedRests { result in
			if case let .success(lastVisitedRests) = result {
				self.latestRestaurants = lastVisitedRests
			}
		}
		
		restaurantsService.ordersHistory { result in
			if case let .success(orders) = result {
				self.orders = orders
			}
		}

        $orders
            .receive(on: DispatchQueue.main)
            .sink { orders in
				var totalSum: Double = 0.0
                orders.forEach({
					if $0.statusCasted != .cancelled {
						totalSum += $0.totalSum
					}
				})
                self.totalSumSpent = totalSum
            }
            .store(in: &cancellableStore)
    }
}

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @ObservedObject var viewModel: ProfileViewModel
	
	private let userService: UserServiceAPI = Service.UserService.shared
    
	init(newOrderSubject: PassthroughSubject<APIResults.OrderAPI, Never>) {
        viewModel = ProfileViewModel(newOrderSubject: newOrderSubject)
    }
    
    var body: some View {
        ScrollView(content: {
            VStack(content: {
                SLProfileHeaderView(imageURL: appViewModel.user?.avatarURL,
                                    title: "")
                
                Text("\(appViewModel.loggedUser?.firstName ?? "") \(appViewModel.loggedUser?.lastName ?? "")")
                    .font(.system(size: 30,
                                  weight: .bold,
                                  design: .rounded))
                    .shadow(radius: 10)
                
                Button(action: {
                    appViewModel.isUserLoggedIn = false
					userService.logout()
                }, label: {
                    Text("Выйти из аккаунта")
                        .font(.system(size: 20,
                                      weight: .bold,
                                      design: .rounded))
                        .shadow(radius: 10)
                })
                
                Divider()
                
				// MARK: - TODO LAST VISITED RESTS
				SecondaryRestaurantsView(restaurants: viewModel.latestRestaurants, title: ViewContext.RestsSections.lastVisited.rawValue)
                
                Divider()
                
                HStack(content: {
					Text("Всего потрачено: \(viewModel.totalSumSpent.stringWithNDecimalPlaces(2)) руб.")
                        .font(.system(size: 18,
                                      weight: .bold,
                                      design: .rounded))
                        .shadow(radius: 10)
                    
                    Spacer()
                })
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                
                Divider()

                VStack(alignment: .leading, content: {
                    HStack(content: {
                        Text("История заказов:")
                            .font(.system(size: 18,
                                          weight: .bold,
                                          design: .rounded))
                            .shadow(radius: 10)
                        
                        Spacer()
                    })

                    ForEach(viewModel.orders, id: \.id, content: { order in
						NavigationLink(destination: {
							CartView(cart: .constant(Cart(allDishes: order.dishes)), isEditable: false)
						},
									   label: {
							OrderRow(order: order, cancelAction: {
								viewModel.restaurantsService.updateOrder(order.id,
																		 updateWith: .cancelled) { result in
									if case let .success(updatedOrder) = result {
										DispatchQueue.main.async {
											guard let index = viewModel.orders.firstIndex(where: { $0.id == updatedOrder.id }) else { return }
											viewModel.orders.remove(at: index)
											viewModel.orders.insert(updatedOrder, at: index)
										}
									}
								}
							})
						})
							.buttonStyle(PlainButtonStyle())
                    })
                        .padding(.top, 10)
                })
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                
                Divider()
            })
		})
			.toolbar(content: {
				NavigationLink(destination: { PaymentMethodsView() }, label: {
					Image(systemName: "creditcard")
				})
			})
        .navigationTitle("@\(appViewModel.loggedUser?.username ?? "")")
    }
}

struct OrderRow: View {
    @State var order: APIResults.OrderAPI
	
	var cancelAction: () -> Void
	
	var statusColor: Color {
		switch order.statusCasted {
		case .active, .done:
			return .green
		case .delayed:
			return .yellow
		case .cancelled:
			return .red
		default:
			return .white
		}
	}
    
    var body: some View {
        HStack(content: {
            VStack(alignment: .leading, content: {
                HStack(content: {
					Text(order.restaurant.name)
					
					Text(order.statusCasted?.plain ?? "")
						.foregroundColor(statusColor)
                })
                
                Text(dateText())
                
				// MARK: - TODO CANCEL ORDERS
				if order.statusCasted == .delayed,
				   let delayedDate = order.date,
				   OrderDatesActionsValidator.shared.isCouldBeCancelled(
					dateString: delayedDate
				   ) {
                    Button(action: {
						order.status = APIResults.OrderStatus.cancelled.rawValue
						cancelAction()
                    }, label: {
                        Text("Отменить заказ")
                        
                        // MARK: - Add validation: Order could be cancelled only in 5 mins after order creation
                        
                        // MARK: - Network call to cancel order
                    })
                }
            })
            
            Spacer()
            
			Text("\(order.totalSum.stringWithNDecimalPlaces(2)) руб.")
			
			Image(systemName: "chevron.right")
        })
    }
    
    func dateText() -> String {
		guard let date = APIDatesFormatter.shared.stringToDate(order.date ?? "") else {
			print("\n\n$0: Failed date with status: \(order.status); id: \(order.id); rest: \(order.restaurant.name)\t\tDate: \(order.date)\n\n")
			
			return ""
		}
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: date)
    }
}
