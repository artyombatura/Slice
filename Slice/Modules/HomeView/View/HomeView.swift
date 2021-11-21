//
//  HomeView.swift
//  Slice
//
//  Created by Artyom Batura on 14.11.21.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView(content: {
            VStack(content: {
                SLProfileHeaderView(image: UIImage(named: "test_avatar"),
                                    username: "artyombatura")
                
                Divider()
                
                Spacer()
            })
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
