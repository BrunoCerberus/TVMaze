//
//  Clamped.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

extension Comparable {
    public func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
