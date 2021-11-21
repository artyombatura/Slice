//
//  SLAvatarCircleView.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import Foundation
import SwiftUI

struct SLAvatarCircleView: View {
    var image: UIImage?
    
    var text: String?
    
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
                .background(Color.blue)
                .clipShape(
                    Circle()
                )
        } else if let text = text,
                  let firstChar = text.first?.uppercased() {
            
            Text(firstChar)
                .font(.system(size: 50.0,
                              weight: .bold,
                              design: .rounded))
                .padding(40)
                .background(
                    Circle()
                        .foregroundColor(Color.blue)
                )
        } else {
            Circle()
                .foregroundColor(.blue)
        }
    }
}

struct SLAvatarCircleView_Preview: PreviewProvider {
    static var previews: some View {
//        SLAvatarCircleView(image: UIImage(named: "test_avatar"))
        
//        SLAvatarCircleView(image: nil)
        
        SLAvatarCircleView(text: "McDonalds")
    }
}
