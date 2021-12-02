//
//  Color+SL.swift
//  Slice
//
//  Created by Artyom Batura on 21.11.21.
//

import Foundation
import SwiftUI

// MARK: - Slice color pallette
extension Color {
    /// Cornflower Blue
    ///
    /// Main color
    ///
    static let slCornflowerBlue: Self = .init(hex: "7189FF")
    
    /// Plump Purple
    ///
    /// Supplementary color #1
    ///
    /// Used for elements shadows and others
    ///
    static let slPlumpPurple: Self = .init(hex: "624CAB")
    
    /// Lavender Blue
    ///
    /// Supplementary color #2
    ///
    /// Used as background color
    ///
    static let slLavenderBlue: Self = .init(hex: "C1CEFE")
    
    static let slUranianBlue: Self = .init(hex: "A0DDFF")
}

// MARK: - Hex Initilizer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
