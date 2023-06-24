//
//  DebugBorderStyle.swift
//  TVMaze
//
//  Created by bruno on 24/06/23.
//

import SwiftUI

#if DEBUG
struct DebugBorderStyle: ViewModifier {
    
    let color: Color = .yellow
    
    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader(content: overlay(for:)))
    }
    
    func overlay(for geometry: GeometryProxy) -> some View {
        ZStack(
            alignment: Alignment(horizontal: .trailing, vertical: .top)
        ) {
            Rectangle()
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 1, dash: [5])
                )
                .foregroundColor(color)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
            
            Text("\(Int(geometry.size.width))x\(Int(geometry.size.height))")
                .font(.caption2)
                .foregroundColor(color)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
                .padding(2)
        }
        .unredacted()
    }
}
#endif
