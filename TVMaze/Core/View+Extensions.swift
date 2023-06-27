//
//  View+Extensions.swift
//  TVMaze
//
//  Created by bruno on 24/06/23.
//

import SwiftUI

extension View {
    var wrappedInViewController: UIViewController {
        let viewController: UIHostingController = UIHostingController(rootView: self)
        viewController.view.frame = UIScreen.main.bounds
        return viewController
    }

    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
#if DEBUG
    /// Debug the tree view structure
    func debug() -> Self {
        debugPrint(Mirror(reflecting: self).subjectType)
        return self
    }

    /// Debug the view layout adding a dashed border to it
    func debugBorder() -> some View {
        modifier(DebugBorderStyle())
    }
#endif
}
