//
//  SLRestaurantSectionView.swift
//  Slice
//
//  Created by Artyom Batura on 21.11.21.
//

import Foundation
import SwiftUI

struct SecondaryRestaurantsView: View {
    // MARK: - Test; Refactor to view models
	var restaurants: [APIResults.RestaurantAPI] = []
	
	var title: String
    
    var body: some View {
        VStack(content: {
            HStack(content: {
                Text(title)
                    .font(.system(size: 24,
                                  weight: .bold,
                                  design: .rounded))
                    .shadow(radius: 10)
                
                Spacer()
            })
                .padding(.horizontal, 16)
            
            ScrollView(
                .horizontal,
                showsIndicators: false,
                content: {
                    HStack(alignment: .top, spacing: 10, content: {
                        ForEach(restaurants, id: \.id, content: { restaurant in
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant), label: {
                                AsyncImage(url: URL(string: restaurant.verifiedPhotoURL), placeholder: { Circle().foregroundColor(.gray) })
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                    .undertitled(with: restaurant.name, color: .black)
                                    .padding(.horizontal, 6)
                            })
                        })
                    })
                })
        })
    }
}
