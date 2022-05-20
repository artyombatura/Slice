//
//  DishDetailView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI

struct DishDetailView: View {
	var dish: APIResults.DishAPI
    
    var addCallback: (APIResults.DishAPI) -> Void
    
    var body: some View {
        ScrollView(content: {
			AsyncImage(url: URL(string: dish.verifiedPhotoURL), placeholder: { Image(uiImage: UIImage(named: "dish_placeholder") ?? UIImage()) })
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
				Text("Время приготовления: \(dish.estimatedTime) мин.")
                    .font(.system(size: 20,
                                  weight: .bold,
                                  design: .rounded))
                    .shadow(radius: 10)
                
                Spacer()
            })
                .padding(.leading, 8)
            
            HStack(content: {
				Text("Вес блюда: \(dish.weight) г.")
                    .font(.system(size: 20,
                                  weight: .bold,
                                  design: .rounded))
                    .shadow(radius: 10)
                
                Spacer()
            })
                .padding(.leading, 8)
			
			if let type = dish.dishType {
				HStack(content: {
					Text("Тип блюда: \(type)")
						.font(.system(size: 20,
									  weight: .bold,
									  design: .rounded))
						.shadow(radius: 10)
					
					Spacer()
				})
					.padding(.leading, 8)
			}
			
			HStack(content: {
				Text("Цена: \(dish.price) руб.")
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
            
            
			if let country = dish.country {
				VStack(spacing: 16) {
					HStack(content: {
						Text("Страна: \(country.name)")
							.font(.system(size: 20,
										  weight: .bold,
										  design: .rounded))
							.shadow(radius: 10)
						
						Spacer()
					})
					
					HStack(content: {
						Text(country.description)
							.font(.system(size: 20,
										  weight: .regular,
										  design: .rounded))
							.shadow(radius: 10)
						
						Spacer()
					})
				}
				.padding(.leading, 8)
				.padding(.top, 20)
			}
        })
		.navigationTitle(dish.name)
    }
}
