//
//  RestaurantView.swift
//  Slice
//
//  Created by Artyom Batura on 3.12.21.
//

import Foundation
import SwiftUI

struct RestaurantView: View {
	var restaurant: APIResults.RestaurantAPI
    
    var body: some View {
        AsyncImage(url: URL(string: restaurant.verifiedPhotoURL),
                   placeholder: { Color.gray })
            .overlay(
                Color.black.opacity(0.4)
            )
            .overlay(
                VStack(content: {
                    Spacer()
                    
                    VStack(content: {
                        Text(restaurant.name)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .white,
                                    radius: 10.0)
                        
                        Text(restaurant.address)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .white,
                                    radius: 10.0)
                    })
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.black.opacity(0.8))
                        )
                    
                    Spacer()
                })
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)
    }
}

//struct RestaurantView_Preview: PreviewProvider {
//    static var previews: some View {
//        RestaurantView(restaurant: .testRestaurant)
//    }
//}
