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
    var restaurantsService: RestaurantsServiceProtocol = MockRestaurantsService()
    
    var ordersService: OrdersServiceProtocol = MockOrdersService()
    
    var newOrderSubject: PassthroughSubject<Order, Never>
    
    @Published var orders = [Order]()
    
    @Published var latestRestaurants = [Restaurant]()
    
    @Published var totalSumSpent: Int = 0
    
    var cancellableStore = Set<AnyCancellable>()
    
    init(newOrderSubject: PassthroughSubject<Order, Never>) {
        self.newOrderSubject = newOrderSubject
        
        newOrderSubject
            .receive(on: DispatchQueue.main)
            .sink { newOrder in
                self.orders.insert(newOrder, at: 0)
            }
            .store(in: &cancellableStore)
        
        restaurantsService.getLastRestaurants { rests in
            self.latestRestaurants = rests
        }
        
        ordersService.getLastOrders(user: "") { orders in
            let sorted = orders.sorted {
                $0.timestamp > $1.timestamp
            }
            self.orders = sorted
        }
        
        $orders
            .receive(on: DispatchQueue.main)
            .sink { orders in
                var totalSum = 0
                orders.forEach({ totalSum += $0.totalSum })
                self.totalSumSpent = totalSum
            }
            .store(in: &cancellableStore)
    }
}

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @ObservedObject var viewModel: ProfileViewModel
    
    init(newOrderSubject: PassthroughSubject<Order, Never>) {
//        _viewModel = StateObject(wrappedValue: ProfileViewModel(newOrderSubject: newOrderSubject))
        viewModel = ProfileViewModel(newOrderSubject: newOrderSubject)
    }
    
    var body: some View {
        ScrollView(content: {
            VStack(content: {
                SLProfileHeaderView(imageURL: appViewModel.user?.avatarURL,
                                    title: "")
                
                Text("\(appViewModel.user?.name ?? "") \(appViewModel.user?.surname ?? "")")
                    .font(.system(size: 30,
                                  weight: .bold,
                                  design: .rounded))
                    .shadow(radius: 10)
                
                Button(action: {
                    appViewModel.isUserLoggedIn = false
                }, label: {
                    Text("Выйти из аккаунта")
                        .font(.system(size: 20,
                                      weight: .bold,
                                      design: .rounded))
                        .shadow(radius: 10)
                })
                
                Divider()
                
                LatestRestaurantsView(restaurants: viewModel.latestRestaurants)
                
                Divider()
                
                HStack(content: {
                    Text("Всего потрачено: \(viewModel.totalSumSpent) руб.")
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
                        OrderRow(order: order)
                    })
                        .padding(.top, 10)
                })
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                
                Divider()
            })
        })
        .navigationTitle("@\(appViewModel.user?.username ?? "")")
    }
}

struct OrderRow: View {
    @State var order: Order
    
    var body: some View {
        HStack(content: {
            VStack(alignment: .leading, content: {
                HStack(content: {
                    Text(order.restaurantName)
                    
                    if order.isActive {
                        Text("Активен")
                            .foregroundColor(.green)
                    }
                })
                
                Text(dateText())
                
                if order.isActive {
                    Button(action: {
                        order.isActive = false
                    }, label: {
                        Text("Отменить заказ")
                        
                        // MARK: - Add validation: Order could be cancelled only in 5 mins after order creation
                        
                        // MARK: - Network call to cancel order
                    })
                }
            })
            
            Spacer()
            
            Text("\(order.totalSum) руб.")
        })
    }
    
    func dateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: order.date)
    }
}
