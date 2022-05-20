//
//  SLVerticalSectionView.swift
//  Slice
//
//  Created by Artyom Batura on 21.11.21.
//

import Foundation
import SwiftUI

struct AllRestaurantsView: View {
	
	// old
    var restaurants: [Restaurant]
	// new
	var rests: [APIResults.RestaurantAPI] = []
    
    var gridItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()),]
    
    var body: some View {
        HStack(content: {
            Text("Все заведения")
                .font(.system(size: 24,
                              weight: .bold,
                              design: .rounded))
                .shadow(radius: 10)

            Spacer()
        })
        .padding(.horizontal, 16)
        
        VStack(content: {
            LazyVGrid(columns: gridItems, spacing: 16, content: {
                ForEach(restaurants, id: \.id, content: { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant), label: {
                        RestaurantView(restaurant: restaurant)
                            .aspectRatio(1.0, contentMode: .fill)
                    })
                })
            })
        })
        .padding(.horizontal, 16)
    }
}
