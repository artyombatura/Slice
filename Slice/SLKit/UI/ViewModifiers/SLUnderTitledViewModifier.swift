//
//  UnderTitledViewModifier.swift
//  Slice
//
//  Created by Artyom Batura on 21.11.21.
//

import Foundation
import SwiftUI

private struct SLUnderTitledViewModifier: ViewModifier {
    var title: String?
    var color: Color = .black
    
    func body(content: Content) -> some View {
        VStack(content: {
            content
            
            Text(title ?? "")
                .lineLimit(1)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(color)
        })
    }
}

extension View {
    func undertitled(with text: String, color: Color = .black) -> some View {
        modifier(SLUnderTitledViewModifier(title: text, color: color))
    }
}
