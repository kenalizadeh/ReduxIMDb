//
//  SimultaneousTapGesture.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import SwiftUI

struct SimultaneousTapGesture: ViewModifier {
    let action: (() -> Void)

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        action()
                    }
            )
    }
}

extension View {
    func simultaneousTapGesture(_ action: @escaping () -> Void) -> some View {
        modifier(SimultaneousTapGesture(action: action))
    }
}
