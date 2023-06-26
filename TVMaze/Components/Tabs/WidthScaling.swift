//
//  WidthScaling.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import SwiftUI

public enum WidthScaleMode {
    case none
    case flexible
}

struct WidthScaling: ViewModifier {
    
    let scaledMode: WidthScaleMode
    let alignment: Alignment
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        switch scaledMode {
        case .none:
            content
        case .flexible:
            content.frame(maxWidth: .infinity, alignment: alignment)
        }
    }
}

extension View {
    public func applyWidthScaling(_ scaleMode: WidthScaleMode, alignment: Alignment = .center) -> some View {
        modifier(WidthScaling(scaledMode: scaleMode, alignment: alignment))
    }

    public func applyWidthScaling(_ scaleMode: WidthScaleMode, horizontalAlignment: HorizontalAlignment) -> some View {
        let alignment: Alignment
        switch horizontalAlignment {
        case .leading:
            alignment = .leading
        case .trailing:
            alignment = .trailing
        default:
            alignment = .center
        }
        return modifier(WidthScaling(scaledMode: scaleMode, alignment: alignment))
    }
}
