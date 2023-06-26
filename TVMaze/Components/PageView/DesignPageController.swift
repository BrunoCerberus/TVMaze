//
//  DesignPageController.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import SwiftUI
import UIKit

final class DesignPageController: UIViewController, UIScrollViewDelegate {
    private lazy var scrollView = UIScrollView()
    
    private var currentPageController: UIViewController? = nil
    private var previousPageController: UIViewController? = nil
    private var nextPageController: UIViewController? = nil
    
    private var currentPage: Int = 0
    private var isAnimating: Bool = false
    private var isPaging: Bool = false
    private var scrollFrame: CGRect = .zero
    
    private var geometry: DesignPageGeometry = DesignPageGeometry()
    
    weak var dataSource: DesignPageControllerDataSource?
    weak var delegate: DesignPageControllerDelegate?
    var direction: DesignPageDirection = .forward
    var orientation: DesignPageOrientation = .horizontal
    var endEditingOnScroll = false
    
    override func loadView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        self.view = scrollView
    }
    
    override func viewDidLayoutSubviews() {
        if scrollFrame != scrollView.frame {
            scrollFrame = scrollView.frame
            update()
            // Prior to now any updates would be positioning based on a zero scroll frame, re-set the page so
            // we move into the correct position (taking the correct scroll frame into account)
            scrollView.contentOffset = geometry.contentRect(forPage: currentPage).origin
        }
    }
    
    func update() {
        // Bail if we don't have a data souce yet, nothing really to do.
        guard let dataSource = self.dataSource else {
            return
        }
        
        geometry = DesignPageGeometry(scrollViewFrame: scrollView.frame,
                                      direction: direction,
                                      orientation: orientation,
                                      pageCount: dataSource.pageCount)
        
        scrollView.contentSize = geometry.contentSize
        updatePages()
    }
    
    func setPage(_ page: Int, animated: Bool) {
        // Bail if we are currently paging or we are already on the right page.
        guard page != currentPage, !isPaging else { return }
        
        currentPage = page
        isAnimating = animated
        
        if animated {
            isPaging = true
        }

        let offset = geometry.contentRect(forPage: page).origin
        scrollView.setContentOffset(offset, animated: animated)
    }
    
    private func updatePages() {
        let previousPage = geometry.previousPage(currentPage)
        let nextPage = geometry.nextPage(currentPage)
        // Remove previous set of views.
        removeControllerViewIfNeeded(controller: previousPageController, page: previousPage)
        removeControllerViewIfNeeded(controller: currentPageController, page: currentPage)
        removeControllerViewIfNeeded(controller: nextPageController, page: nextPage)
        // Setup and add new set of views
        previousPageController = setupController(forPage: geometry.previousPage(currentPage))
        currentPageController = setupController(forPage: currentPage)
        nextPageController = setupController(forPage: geometry.nextPage(currentPage))
    }
    
    /// Will remove the controller's view, but only if the next page is using a new controller.
    /// Limiting when we are removing the controller's view will prevent UI events from being
    /// cancelled when it's updated.
    private func removeControllerViewIfNeeded(controller: UIViewController?, page: Int?) {
        guard let page = page else {
            return
        }
        
        if controller != dataSource?.peekControllerCache(forPage: page) {
            controller?.view?.removeFromSuperview()
        }
    }
    
    private func setupController(forPage page: Int?) -> UIViewController? {
        guard let page = page,
              let dataSource = self.dataSource else {
            return nil
        }
        
        let controller = dataSource.controller(forPage: page)
        controller.view.frame = geometry.contentRect(forPage: page)
        scrollView.addSubview(controller.view)
        
        return controller
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newPage = geometry.page(forContentOffset: scrollView.contentOffset)
        if newPage != currentPage {
            currentPage = newPage
            updatePages()
            
            notifyStateChanged()
        }
        
        notifyScrollOccured(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isAnimating = false
        isPaging = false
        notifyStateChanged()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !isPaging {
            isPaging = true
            notifyStateChanged()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && isPaging {
            isPaging = false
            notifyStateChanged()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isPaging {
            isPaging = false
            notifyStateChanged()
        }
    }
    
    private func notifyStateChanged() {
        let isPagingInAnyWay = isPaging || isAnimating
        delegate?.pageControllerDidChangeState(self, newPage: currentPage, isPaging: isPagingInAnyWay)
    }
    
    private func notifyScrollOccured(_ scrollView: UIScrollView) {
        if endEditingOnScroll {
            scrollView.endEditing(true)
        }
        let position = geometry.pagePosition(forContentOffset: scrollView.contentOffset)
        delegate?.pageControllerDidScroll(self, scrollOffset: scrollView.contentOffset, position: position)
    }
}
