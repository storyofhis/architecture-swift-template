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
                .font(.system(size: 27, weight: .bold))
                .lineSpacing(6)

        case .body:
            content
                .font(.system(size: 17, weight: .regular))
                .lineSpacing(4)

        case .button:
            content
                .font(.system(size: 17, weight: .semibold))
                .kerning(1.2)

        case .caption:
            content
                .font(.system(size: 13, weight: .medium))
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
