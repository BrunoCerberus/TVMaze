//
//  PageView.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import SwiftUI
import UIKit

public struct PageView<Page: View>: View {
    private let pages: [Page]
    private let currentPage: Binding<Int>
    private let currentPosition: Binding<CGFloat>
    private let isPaging: Binding<Bool>
    private let shouldUpdateOnRender: Bool
    private let endEditingOnScroll: Bool
    
    @Environment (\.pageViewOrientation) private var orientation: DesignPageOrientation
    @Environment (\.pageViewDirection) private var direction: DesignPageDirection
    
    public init(pages: [Page],
                currentPage: Binding<Int>? = nil,
                currentPosition: Binding<CGFloat> = Binding.constant(0.0),
                isPaging: Binding<Bool> = Binding.constant(false),
                shouldUpdateOnRender: Bool = true,
                endEditingOnScroll: Bool = false) {
        self.pages = pages
        self.isPaging = isPaging
        self.currentPosition = currentPosition
        self.shouldUpdateOnRender = shouldUpdateOnRender
        self.endEditingOnScroll = endEditingOnScroll
        if let pageBinding = currentPage {
            self.currentPage = pageBinding
        } else {
            var defaultPage: Int = 0
            self.currentPage = Binding(get: { defaultPage }, set: { newValue in defaultPage = newValue })
        }
    }
    
    public var body: some View {
        PageViewControllerRepresentable(pages: pages,
                                        navigationOrientation: orientation,
                                        direction: direction,
                                        isPaging: isPaging,
                                        currentPage: currentPage,
                                        currentPosition: currentPosition,
                                        shouldUpdateOnRender: shouldUpdateOnRender,
                                        shouldCacheControllers: true,
                                        endEditingOnScroll: endEditingOnScroll)
    }
}
