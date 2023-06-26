//
//  DesignPageControllerDelegate.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

protocol DesignPageControllerDelegate: AnyObject {
    func pageControllerDidChangeState(_ pageController: DesignPageController, newPage: Int, isPaging: Bool)
    func pageControllerDidScroll(_ pageController: DesignPageController, scrollOffset: CGPoint, position: CGFloat)
}
