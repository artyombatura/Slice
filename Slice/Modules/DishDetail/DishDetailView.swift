//
//  DishDetailView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI

//class

struct DishDetailView: View {
    var dish: Dish
    
    var addCallback: (Dish) -> Void
    
    var body: some View {
        ScrollView(content: {
            AsyncImage(url: URL(string: dish.photoURL), placeholder: { Image(uiImage: UIImage(named: "dish_placeholder") ?? UIImage()) })
                .aspectRatio(1.0, contentMode: .fill)
            
            Button(action: {
                addCallback(dish)
            }, label: {
                Text("Добавить")
                    .font(.system(size: 24,
                                  weight: .bold,
                                  design: .rounded))
                    .shadow(radius: 10)
            })
            
            HStack(content: {
                Text("Время приготовления: \(dish.estimatedCookingTime) мин.")
                    .font(.system(size: 20,
                                  weight: .bold,
                                  design: .rounded))
                    .shadow(radius: 10)
                
                Spacer()
            })
                .padding(.leading, 8)
            
            HStack(content: {
                Text("Вес блюда: \(Int(dish.weight ?? 0.0)) г.")
                    .font(.system(size: 20,
                                  weight: .bold,
                                  design: .rounded))
                    .shadow(radius: 10)
                
                Spacer()
            })
                .padding(.leading, 8)
            
            VStack(spacing: 16, content: {
                HStack(content: {
                    Text("Описание: ")
                        .font(.system(size: 20,
                                      weight: .bold,
                                      design: .rounded))
                        .shadow(radius: 10)
                    
                    Spacer()
                })
                
                HStack(content: {
                    Text(dish.description)
                        .font(.system(size: 20,
                                      weight: .regular,
                                      design: .rounded))
                        .shadow(radius: 10)
                    
                    Spacer()
                })
            })
                .padding(.leading, 8)
                .padding(.top, 20)
            
            
        })
        .navigationTitle(dish.name)
    }
}
