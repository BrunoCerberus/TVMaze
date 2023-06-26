//
//  DesignPageGeometry.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

struct DesignPageGeometry {
    var scrollViewFrame: CGRect = .zero
    var direction: DesignPageDirection = .forward
    var orientation: DesignPageOrientation = .horizontal
    var pageCount: Int = 0
    
    /// Returns the entire size of the page controller's scroll content.
    var contentSize: CGSize {
        switch orientation {
        case .horizontal:
            let width = scrollViewFrame.width * CGFloat(pageCount)
            return CGSize(width: width, height: 0)
        case .vertical:
            let height = scrollViewFrame.height * CGFloat(pageCount)
            return CGSize(width: 0, height: height)
        }
    }
    
    /// Returns the content rect for a page. This will take into account direction (reversing if needed)
    func contentRect(forPage page: Int) -> CGRect {
        let adjusted = adjustedPage(page)
        switch orientation {
        case .horizontal:
            return CGRect(x: CGFloat(adjusted) * scrollViewFrame.width,
                          y: 0,
                          width: scrollViewFrame.width,
                          height: scrollViewFrame.height)
        case .vertical:
            return CGRect(x: 0,
                          y: CGFloat(adjusted) * scrollViewFrame.height,
                          width: scrollViewFrame.width,
                          height: scrollViewFrame.height)
        }
    }
    
    /// Returns the page position for the given content. At rest on page 2 this would be 2.0 ( or count - 2.0).
    func pagePosition(forContentOffset offset: CGPoint) -> CGFloat {
        let position: CGFloat
        
        switch orientation {
        case .horizontal:
            position = offset.x / scrollViewFrame.width
        case .vertical:
            position = offset.y / scrollViewFrame.height
        }
        
        return position
    }
    
    /// Returns the page for the given offset this will take direction into account (reversing if needed).
    func page(forContentOffset offset: CGPoint) -> Int {
        let page: Int
        
        switch orientation {
        case .horizontal:
            page = Int(floor(offset.x / scrollViewFrame.width))
        case .vertical:
            page = Int(floor(offset.y / scrollViewFrame.height))
        }
        
        let clamped = clampedPage(page)
        return adjustedPage(clamped)
    }
    
    /// Returns the previous page (respecting direction, but swapping back to the un-reversed version).
    func previousPage(_ page: Int) -> Int? {
        let adjusted = adjustedPage(page)
        guard adjusted > 0 else {
            return nil
        }
        
        return adjustedPage(adjusted - 1)
    }
    
    /// Returns the next page (respecting direction, but swapping back to the un-reversed version).
    func nextPage(_ page: Int) -> Int? {
        let adjusted = adjustedPage(page)
        guard adjusted < pageCount - 1 else {
            return nil
        }
        
        return adjustedPage(adjusted + 1)
    }
    
    /// Adjusts the page for the provided direction (reversing if needed).
    private func adjustedPage(_ page: Int) -> Int {
        switch direction {
        case .forward:
            return clampedPage(page)
        case .reverse:
            return clampedPage(pageCount - page - 1)
        }
    }
    
    private func clampedPage(_ page: Int) -> Int {
        guard pageCount > 0 else { return 0 }
        
        return page.clamped(to: 0...pageCount-1)
    }
}
