//
//  DesignPageControllerDataSource.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import UIKit
import SwiftUI

protocol DesignPageControllerDataSource: AnyObject {
    var pageCount: Int { get }
    func controller(forPage page: Int) -> UIViewController
    func peekControllerCache(forPage page: Int) -> UIViewController?
}
