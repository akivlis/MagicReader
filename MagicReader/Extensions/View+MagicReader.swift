//
//  UIView+MagicReader.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 25.04.22.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
