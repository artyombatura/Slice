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
            Spacer()
            
            VStack(content: {
                SLAvatarCircleView(image: image ?? UIImage())
                    .frame(width: 150, height: 150)
                
                Text("@\(username)")
                    .font(.system(size: 30.0,
                                  weight: .bold,
                                  design: .rounded))
            })
            
        
            
            Spacer()
        })
    }
}

struct SLProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SLProfileHeaderView(image: UIImage(named: "test_avatar"),
                            username: "artyombatura")
    }
}
