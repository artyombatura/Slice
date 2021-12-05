//
//  SLProfileHeaderView.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import Foundation
import SwiftUI

struct SLProfileHeaderView: View {
    var imageURL: String?
    
    var title: String
    
    var body: some View {
        HStack(content: {
            VStack(content: {
                AsyncImage(url: URL(string: imageURL ?? ""), placeholder: { Circle().foregroundColor(.gray) })
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(color: .black, radius: 20, x: 0, y: 0)
                
                Text("\(title)")
                    .font(.system(size: 16,
                                  weight: .medium,
                                  design: .rounded))
                    .foregroundColor(.black)
                    .shadow(radius: 10)
            })
        })
    }
}
