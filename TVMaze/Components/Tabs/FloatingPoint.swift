//
//  FloatingPoint.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

public extension FloatingPoint {
    func interpolate(to number: Self, percent: Self) -> Self {
        return self + (number - self) * percent
    }
}
