//
//  DishView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI

struct DishView: View {
	var dish: APIResults.DishAPI
    
    var addCallback: (APIResults.DishAPI) -> Void
    
    var body: some View {
		AsyncImage(url: URL(string: dish.verifiedPhotoURL),
                   placeholder: { Color.gray })
            .overlay(
                Color.black.opacity(0.4)
            )
            .overlay(
                VStack(content: {
                    Spacer()
                    
                    VStack(content: {
                        Text(dish.name)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .white,
                                    radius: 10.0)
                    })
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.black.opacity(0.8))
                        )
                    
                    Button(action: {
                        print("\(dish.name) добавлено в корзину")
                    }, label: {
                        Button(action: {
                            addCallback(dish)
                        }, label: {
                            Text("Добавить")
                                .foregroundColor(.white)
                        })
                    })
                })
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)
    }
}
