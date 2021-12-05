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
        
    var body: some View {
        List(content: {
            ForEach(cart.dishes, id: \.id, content: { dishFromCart in
                HStack(content: {
                    AsyncImage(url: URL(string: dishFromCart.photoURL), placeholder: { Rectangle().foregroundColor(.gray) })
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
                .onDelete { index in
                    delete(at: index)
                }
        })
            .navigationTitle("Заказ: \(cart.totalSum) руб.")
    }
    
    func delete(at offsets: IndexSet) {
        cart.dishes.remove(atOffsets: offsets)
    }
}
