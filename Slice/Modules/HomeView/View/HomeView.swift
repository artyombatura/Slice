//
//  HomeView.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import Foundation
import SwiftUI

class HomeViewViewModel: ObservableObject {
    @Published var restaurantSections: RestaurantSection
    
    init() {
        restaurantSections = RestaurantSection(name: "Latest", restaurants: [
            Restaurant(name: "KFC"),
            Restaurant(name: "McDonalds"),
            Restaurant(name: "Burger King"),
            Restaurant(name: "Dominos"),
            Restaurant(name: "Papa Johns")
        ])
    }
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewViewModel()
    
    var body: some View {
        ZStack {
            ScrollView(content: {
                VStack(content: {
                    SLProfileHeaderView(image: UIImage(named: "test_avatar"),
                                        username: "artyombatura")
                    
                    Divider()
                    
                    SLHorizontalRowSectionView(section: viewModel.restaurantSections)
                        .padding(.top, 20)
                    
                    SLVerticalSectionView(section: viewModel.restaurantSections)
                        .padding(.top, 20)
                })
            })
            
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 100)
                    .foregroundColor(.white)
                    .overlay(
                        VStack(content: {
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: 50, height: 5)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                            
                            Spacer()
                            
                            HStack {
                                Text("Заказ в McDonalds")
                                    .font(.system(.title2, design: .monospaced))
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text("11.99$")
                                    .font(.system(.callout, design: .monospaced))
                            }
                            .padding(.horizontal, 16)
                            
                            Spacer()
                        })
                    )
                    .shadow(radius: 10)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
