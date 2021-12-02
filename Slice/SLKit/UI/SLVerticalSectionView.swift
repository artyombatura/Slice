//
//  SLVerticalSectionView.swift
//  Slice
//
//  Created by Artyom Batura on 21.11.21.
//

import Foundation
import SwiftUI

struct SLVerticalSectionView: View {
    var section: RestaurantSection
    
    private var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 200)), count: 2)
    }
    
    var body: some View {
        Group {
            HStack(content: {
                Text("All")
                    .font(.system(size: 24,
                                  weight: .bold,
                                  design: .rounded))
//                    .foregroundColor(.slPlumpPurple)
                    .shadow(radius: 10)
                
                Spacer()
            })
            
            VStack(content: {
                ForEach(section.restaurants, id: \.id, content: { restaurant in
                    HStack(content: {
                        SLCircleView(text: restaurant.name)
                        
                        Text(restaurant.name)
                        
                        Spacer()
                    })
                    .frame(height: 100)
                })
            })
        }
        .padding(.horizontal, 16)
    }
}
