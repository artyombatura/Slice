//
//  HomeView.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import Foundation
import SwiftUI

class HomeViewViewModel: ObservableObject {
    var restaurantsService: RestaurantsServiceProtocol = MockRestaurantsService()
    
    @Published var latestRestaurants = [Restaurant]()
    
    @Published var restaurants = [Restaurant]()
    
    init() {
        restaurantsService.getRestaurants { rests in
            self.restaurants = rests
        }
        
        restaurantsService.getLastRestaurants { rests in
            self.latestRestaurants = rests
        }
    }
}

struct HomeView: View {
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
                    
                    Divider()

                    LatestRestaurantsView(restaurants: viewModel.latestRestaurants)
                    
                    Divider()
                    
                    AllRestaurantsView(restaurants: viewModel.restaurants)
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
