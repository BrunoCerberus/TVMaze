//
//  View+Geometry.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import SwiftUI

public extension View {
    func sizeReader(sizeUpdate: @escaping (CGSize) -> Void) -> some View {
        background(GeometryReader { geometry in
            Color.clear
                .onAppear {
                    sizeUpdate(geometry.size)
                }.onChange(of: geometry.size) { _ in
                    sizeUpdate(geometry.size)
                }
        })
    }
    
    func positionReader(_ coordinateSpace: CoordinateSpace = .local,
                        positionUpdate: @escaping (CGPoint) -> Void) -> some View {
        background(GeometryReader { geometry in
            Color.clear
                .onAppear {
                    positionUpdate(geometry.frame(in: coordinateSpace).origin)
                }.onChange(of: geometry.frame(in: coordinateSpace).origin) { _ in
                    positionUpdate(geometry.frame(in: coordinateSpace).origin)
                }
        })
    }
}
