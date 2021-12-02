//
//  Restaurant.swift
//  Slice
//
//  Created by Artyom Batura on 21.11.21.
//

import Foundation

struct Restaurant: Identifiable {
    var id: String = UUID().uuidString
    
    // MARK: - Model main properties
    var name: String
    
    // MARK: - Computed accessory properties
    var firstCharOfName: String {
        String(name.first ?? Character(""))
    }
}
