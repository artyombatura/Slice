//
//  DishDetailView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI

struct DishDetailView: View {
	@Environment(\.presentationMode) var presentationMode
	var dish: APIResults.DishAPI
    
    var addCallback: (APIResults.DishAPI) -> Void
    
    var body: some View {
		ZStack {
        	ScrollView(content: {
				VStack {
					AsyncImage(url: URL(string: dish.verifiedPhotoURL), placeholder: { Image(uiImage: UIImage(named: "dish_placeholder") ?? UIImage()) })
						.aspectRatio(1.0, contentMode: .fill)
					
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
				}
					.padding(.bottom, 80)
        	})
			
			VStack(content: {
				Spacer()
				
				RoundedRectangle(cornerRadius: 100)
					.foregroundColor(.white)
					.frame(height: 60)
					.shadow(radius: 10)
					.overlay(
						Text("Добавить")
					)
					.onTapGesture {
						addCallback(dish)
						presentationMode.wrappedValue.dismiss()
					}
			})
			.padding(.horizontal, 16)
		}
		.navigationTitle(dish.name)
    }
}
