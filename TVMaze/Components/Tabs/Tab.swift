//
//  Tab.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation
import SwiftUI

public struct Tab: View {
    private var label: String
    private var isActive: Bool
    
    public init(label: String, isActive: Bool) {
        self.label = label
        self.isActive = isActive
    }
    
    public var body: some View {
        Text(label)
            .font(.secondary(.large, weight: .semibold))
            .foregroundColor(isActive ? Color.white : Color.white70)
            .padding(.vertical, Layout.padding(1.5))
    }
}
