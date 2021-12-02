//
//  SLProfileHeaderView.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import Foundation
import SwiftUI

struct SLProfileHeaderView: View {
    var image: UIImage?
    
    var username: String
    
    var body: some View {
        HStack(content: {
//            Spacer()
            
            VStack(content: {
                SLCircleView(image: image ?? UIImage())
                    .frame(width: 150, height: 150)
                    .shadow(color: .slCornflowerBlue, radius: 20, x: 0, y: 0)
                
                Text("@\(username)")
                    .font(.system(size: 16,
                                  weight: .medium,
                                  design: .rounded))
                    .foregroundColor(.black)
                    .shadow(radius: 10)
            })

//            Spacer()
        })
    }
}

struct SLProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SLProfileHeaderView(image: UIImage(named: "test_avatar"),
                            username: "artyombatura")
    }
}
