//
//  CustomFont.swift
//
//
//  Created by Masakaz Ozaki on 2024/02/24.
//

import SwiftUI

struct CustomFontModifier: ViewModifier {
    var size: CGFloat

    func body(content: Content) -> some View {
        content.font(Font(UIFont(name: "Ounen-mouhitsu", size: size) ?? UIFont()))
    }
}

extension View {
    func calligraphyFont(size: CGFloat) -> some View {
        self.modifier(CustomFontModifier(size: size))
    }
}
