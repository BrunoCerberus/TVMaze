//
//  PageViewModifiers.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import SwiftUI

struct PageViewDirectionKey: EnvironmentKey {
    public static var defaultValue: DesignPageDirection = .forward
}

struct PageViewOrientationKey: EnvironmentKey {
    public static var defaultValue: DesignPageOrientation = .horizontal
}

struct PageViewWrappedKey: EnvironmentKey {
    public static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var pageViewOrientation: DesignPageOrientation {
        get { self[PageViewOrientationKey.self] }
        set { self[PageViewOrientationKey.self] = newValue }
    }
    
    var pageViewDirection: DesignPageDirection {
        get { self[PageViewDirectionKey.self] }
        set { self[PageViewDirectionKey.self] = newValue }
    }
    
    var pageViewWrapped: Bool {
        get { self[PageViewWrappedKey.self] }
        set { self[PageViewWrappedKey.self] = newValue }
    }
}

public extension View {
    func pageViewOrientation(_ orientation: DesignPageOrientation) -> some View {
        environment(\.pageViewOrientation, orientation)
    }
    
    func pageViewDirection(_ direction: DesignPageDirection) -> some View {
        environment(\.pageViewDirection, direction)
    }
}
