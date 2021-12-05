//
//  SLAvatarCircleView.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import Foundation
import SwiftUI

struct SLCircleView: View {
    var image: UIImage?
    
    var text: String?
    
    var color: Color = .black
    
    init(image: UIImage? = nil,
         text: String? = nil) {
        self.image = image
        self.text = text
    }
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .background(color)
                .clipShape(
                    Circle()
                )
        } else if let text = text,
                  let firstChar = text.first?.uppercased() {
            
            Text(firstChar)
                .font(.system(size: 50.0,
                              weight: .bold,
                              design: .rounded))
                .foregroundColor(.black)
                .padding(20)
                .background(
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                )

        } else {
            Circle()
                .foregroundColor(color)
        }
    }
}

struct SLCircleView_Preview: PreviewProvider {
    static var previews: some View {
        SLCircleView(text: "McDonalds")
    }
}
