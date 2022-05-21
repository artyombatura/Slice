//
//  HomeView.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import Foundation
import SwiftUI

class HomeViewViewModel: ObservableObject {
	// old
//    var restaurantsService: RestaurantsServiceProtocol = MockRestaurantsService()
//    
//    @Published var latestRestaurants = [Restaurant]()
//    
//    @Published var restaurants = [Restaurant]()
	
	// new
	let restsService: RestaurantServiceAPI = Service.Restaurant.shared
	
	@Published var allRests = [APIResults.RestaurantAPI]()
	@Published var lastVisitedRests = [APIResults.RestaurantAPI]()
	@Published var popularRests = [APIResults.RestaurantAPI]()
    
    init() {
		restsService.fetchAllRests { result in
			if case let .success(rests) = result {
				DispatchQueue.main.async {
					self.allRests = rests
				}
			}
		}
		
		restsService.fetchLastVisitedRests { result in
			if case let .success(rests) = result {
				DispatchQueue.main.async {
				self.lastVisitedRests = rests
				}
			}
		}
		
		restsService.fetchPopularRests { result in
			if case let .success(rests) = result {
				DispatchQueue.main.async {
				self.popularRests = rests
				}
			}
		}
		
//        restaurantsService.getRestaurants { rests in
//            self.restaurants = rests
//        }
//
//        restaurantsService.getLastRestaurants { rests in
//            self.latestRestaurants = rests
//        }
    }
}

struct HomeView: View {
	typealias RestsSections = ViewContext.RestsSections
	
    @EnvironmentObject var appViewModel: AppViewModel
    
    @StateObject var viewModel = HomeViewViewModel()
    
    var body: some View {
        
            ScrollView(content: {
                VStack(content: {
                    NavigationLink(destination: ProfileView(newOrderSubject: appViewModel.newOrderSubject),
                                   label: {
                        SLProfileHeaderView(imageURL: appViewModel.user?.avatarURL,
                                            title: "")
                    })
                    
					if viewModel.lastVisitedRests.isNotEmpty {
                    	Divider()

						SecondaryRestaurantsView(restaurants: viewModel.lastVisitedRests, title: RestsSections.lastVisited.rawValue)
					}
                    
                    Divider()
					
					SecondaryRestaurantsView(restaurants: viewModel.popularRests, title: RestsSections.popular.rawValue)
					
					Divider()
                    
					RestaurantsView(rests: viewModel.allRests, title: RestsSections.all.rawValue)
                })
            })
			.navigationTitle("@\(appViewModel.loggedUser?.username ?? "")")
            
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension Collection {
	var isNotEmpty: Bool {
		!isEmpty
	}
}

enum ViewContext {
	enum RestsSections: String {
		case all = "Все заведения"
		case lastVisited = "Последние посещенные"
		case popular = "Популярные"
	}
}
