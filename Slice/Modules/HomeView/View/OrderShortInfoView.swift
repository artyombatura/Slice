//
//  OrderShortInfoView.swift
//  Slice
//
//  Created by Artyom Batura on 3.12.21.
//

import Foundation
import SwiftUI

struct OrderShortInfoView: View {
    var body: some View {
        VStack {
            Spacer()
            
            RoundedRectangle(cornerRadius: 30)
                .frame(height: 100)
                .foregroundColor(.white)
                .overlay(
                    VStack(content: {
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 50, height: 5)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        HStack {
                            Text("Заказ в McDonalds")
                                .font(.system(.title2, design: .monospaced))
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("11.99$")
                                .font(.system(.callout, design: .monospaced))
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    })
                )
                .shadow(radius: 10)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct OrderShortInfoView_Preview: PreviewProvider {
    static var previews: some View {
        OrderShortInfoView()
    }
}

