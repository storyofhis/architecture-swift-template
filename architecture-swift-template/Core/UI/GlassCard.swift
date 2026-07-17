//
//  GlassCard.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 17/07/26.
//

import SwiftUI

private struct GlassCardModifier: ViewModifier {

    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding()
            .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
    }
}

extension View {

    /// Wraps the view in Apple's Liquid Glass material, shaped as a rounded card.
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}
