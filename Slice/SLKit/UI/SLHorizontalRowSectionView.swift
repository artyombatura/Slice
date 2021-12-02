//
//  SLRestaurantSectionView.swift
//  Slice
//
//  Created by Artyom Batura on 21.11.21.
//

import Foundation
import SwiftUI

struct SLHorizontalRowSectionView: View {
    var section: RestaurantSection
    
    var body: some View {
        VStack(content: {
            HStack(content: {
                Text(section.name)
                    .font(.system(size: 24,
                                  weight: .bold,
                                  design: .rounded))
//                    .foregroundColor(.slPlumpPurple)
                    .shadow(radius: 10)
                
                Spacer()
            })
            
            ScrollView(
                .horizontal,
                showsIndicators: false,
                content: {
                    HStack(alignment: .top, spacing: 10, content: {
                        ForEach(section.restaurants, id: \.id, content: { restaurant in
                            SLCircleView(text: restaurant.name)
                                .frame(width: 100)
                                .undertitled(with: restaurant.name,
                                             color: .white)
                        })
                    })
                })
                .boxBackground(color: .slPlumpPurple)
        })
        .padding(.horizontal, 16)
    }
}
