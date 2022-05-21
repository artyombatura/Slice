//
//  CartView.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation
import SwiftUI 

struct CartView: View {
    @Binding var cart: Cart
	var isEditable: Bool = true
        
    var body: some View {
        List(content: {
			ForEach(cart.allDishes, id: \.id, content: { dishFromCart in
                HStack(content: {
					AsyncImage(url: URL(string: dishFromCart.verifiedPhotoURL), placeholder: { Rectangle().foregroundColor(.gray) })
                            .frame(width: 100, height: 100)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    
					Text(dishFromCart.name)
                        .font(.system(size: 20,
                                      weight: .regular,
                                      design: .rounded))
                    
                    Spacer()
                    
                    Text("\(dishFromCart.price) руб.")
                        .font(.system(size: 20,
                                      weight: .regular,
                                      design: .rounded))
                })
            })
				.if(isEditable) { view in
					view
						.onDelete { index in
							delete(at: index)
						}
				}
        })
			.navigationTitle("Заказ: \(cart.totalSum.stringWithNDecimalPlaces(2)) руб.")
    }
    
    func delete(at offsets: IndexSet) {
        cart.allDishes.remove(atOffsets: offsets)
    }
}


extension View {
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}
