//
//  FontStyle.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 19/05/26.
//

import SwiftUI

enum DesignSystem {}

extension DesignSystem {

    enum Typography {
        case title
        case body
        case button
        case caption
    }
}

fileprivate struct TypographyModifier: ViewModifier {

    let style: DesignSystem.Typography

    func body(content: Content) -> some View {

        switch style {

        case .title:
            content
                .font(.title.bold())
                .lineSpacing(6)

        case .body:
            content
                .font(.body)
                .lineSpacing(4)

        case .button:
            content
                .font(.headline)
                .kerning(1.2)

        case .caption:
            content
                .font(.caption)
                .kerning(0.5)
        }
    }
}

extension View {

    func typography(
        _ typography: DesignSystem.Typography
    ) -> some View {

        self.modifier(
            TypographyModifier(style: typography)
        )
    }
}
