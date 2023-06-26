//
//  PageViewControllerRepresentable.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import SwiftUI
import UIKit

struct PageViewControllerRepresentable<Page: View>: UIViewControllerRepresentable {
    private var pages: [Page]
    private let navigationOrientation: DesignPageOrientation
    private let direction: DesignPageDirection
    
    private let shouldUpdateOnRender: Bool
    private let shouldCacheControllers: Bool
    private let endEditingOnScroll: Bool
    
    @Binding private var isPaging: Bool
    @Binding private var currentPage: Int
    @Binding private var currentPosition: CGFloat
    
    init(pages: [Page] = [],
         navigationOrientation: DesignPageOrientation = .horizontal,
         direction: DesignPageDirection = .forward,
         isPaging: Binding<Bool>,
         currentPage: Binding<Int>,
         currentPosition: Binding<CGFloat>,
         shouldUpdateOnRender: Bool,
         shouldCacheControllers: Bool,
         endEditingOnScroll: Bool = false
    ) {
        self.pages = pages
        self.navigationOrientation = navigationOrientation
        self.direction = direction
        self.shouldUpdateOnRender = shouldUpdateOnRender
        self.shouldCacheControllers = shouldCacheControllers
        self.endEditingOnScroll = endEditingOnScroll
        _isPaging = isPaging
        _currentPage = currentPage
        _currentPosition = currentPosition
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DesignPageController {
        let pageController = DesignPageController()
        pageController.dataSource = context.coordinator
        pageController.delegate = context.coordinator
        pageController.direction = direction
        pageController.orientation = navigationOrientation
        pageController.endEditingOnScroll = endEditingOnScroll
        return pageController
    }
    
    func updateUIViewController(_ pageController: DesignPageController, context: Context) {
        context.coordinator.parent = self
        pageController.direction = direction
        pageController.orientation = navigationOrientation
        
        guard !isPaging else {
            context.coordinator.needsUpdate = shouldUpdateOnRender
            return
        }
        
        let animated = context.transaction.animation != nil
        pageController.setPage(currentPage, animated: animated)
        
        if shouldUpdateOnRender {
            pageController.update()
        }
    }
    
    final class Coordinator: NSObject, DesignPageControllerDataSource, DesignPageControllerDelegate {
        var parent: PageViewControllerRepresentable
        var needsUpdate = false
        private var controllers: [Int: UIHostingController<Page>] = [:]
        
        init(_ parent: PageViewControllerRepresentable) {
            self.parent = parent
        }
        
        var pageCount: Int {
            parent.pages.count
        }
        
        func controller(forPage page: Int) -> UIViewController {
            let pageView = view(forPage: page)
            let controller = controllers[page] ?? UIHostingController(rootView: pageView)
            controller.rootView = pageView
            controller.view.backgroundColor = .clear
            
            if parent.shouldCacheControllers {
                controllers[page] = controller
            }
            
            return controller
        }
        
        func peekControllerCache(forPage page: Int) -> UIViewController? {
            controllers[page]
        }
        
        private func view(forPage page: Int) -> Page {
            parent.pages[page]
        }
        
        func pageControllerDidChangeState(_ pageController: DesignPageController, newPage: Int, isPaging: Bool) {
            parent.isPaging = isPaging
            if !isPaging {
                parent.currentPage = newPage
                // Check if we need an update
                if needsUpdate {
                    needsUpdate = false
                    pageController.update()
                }
            }
        }
        
        func pageControllerDidScroll(_ pageController: DesignPageController, scrollOffset: CGPoint, position: CGFloat) {
            parent.currentPosition = position
        }
    }
}
